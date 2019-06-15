local M = {}

local Animator = require "Animator"
local KonachanAPI = require "KonachanAPI"
local Share = require "Libs.Share"
local DpiLib = require "Libs.DpiLib"
local Utility = require "Libs.Utility"
local Language = require "Language"
local Toast = require "Toast"
local composer = require "composer"
local Preferences = require "Preferences"
local Loader = require "Loader"
local crypto = require "crypto"
local Feedback = require "Libs.Feedback"
local Wallpaper = require "Wallpaper"

local hiddenLoading
local networkId
local timerAds

local view

local mAbs = math.abs
local mRand = math.random
local toolBarButtonsHandle

local initToolBarButtonsHandle
, initHiddenLoading
, downloadImage
, getImagePool
, isImage
, onLoadingComplete
, showTutorialButtons
, showTutorialSwipe
, showTutorial
, tryShowRandomImage
, onShareComplete
, showActivityIndicator
, hideActivityIndicator
, errorHandle
, errorNetworkConnection
, errorResponseType


function M.init(scene)
	view = scene
	toolBarButtonsHandle = initToolBarButtonsHandle()

	showTutorialButtons()
	tryShowRandomImage()
end

function M.show(event)
	if event.phase == "will" then

	elseif event.phase == "did" then

	end
end

function M.hide(event)
	if event.phase == "will" then

	elseif event.phase == "did" then
		Animator.stop()
	end
end

function M.toolBarController(event)
	Utility.scaleObject(event, 0.9)

	if event.phase == "ended" then
		local buttonName = event.target.name

		if toolBarButtonsHandle[buttonName] then
			toolBarButtonsHandle[buttonName]()
		end
	end

	return true
end

function M.gestureController(event)
	if view.sliderIsLocked() then
		return
	end

	local target = event.target
	local stack = target.stack

	if event.phase == "moved" then
		if not target.isFocus then
			display.getCurrentStage():setFocus(target, event.id)
			target.isFocus = true
		end
	end

	if target.isFocus then
		if event.phase == "moved" then
			for i = 1, #stack do
				stack[i].x = event.x - event.xStart + stack[i].xBegin
			end

		elseif event.phase == "ended" or event.phase == "cancelled" then
			display.getCurrentStage():setFocus(nil)
			target.isFocus = false

			local xDistance = mAbs(event.x - event.xStart)
			local xMinDistance = display.contentWidth*0.1
			local toLeft = (event.x < event.xStart) and true or false

			if xDistance > xMinDistance then
				if toLeft then
					M.showRandomImage()
				else
					if view.sliderIsLeftBorder() then
						for i = 1, #stack do
							Animator.moveToBegin(stack[i])
						end
					else
						view.sliderPrev()
					end
				end
			else
				for i = 1, #stack do
					Animator.moveToBegin(stack[i])
				end
			end
		end
	end

	return true
end

function M.showRandomImage()
	if hiddenLoading then
		if view.sliderIsRightBorder() then
			showActivityIndicator()
			hiddenLoading = false
		else
			view.sliderNext()
		end
	else
		if view.sliderIsRightBorder() then
			showActivityIndicator()
			networkId = KonachanAPI.getImage(downloadImage)
		else
			view.sliderNext()
			initHiddenLoading()
		end
	end

	showTutorialSwipe()
end

function M.shareImage()
	local filename, baseDir = view.sliderGetCurrentImage()

	if not filename then
		Toast.show(Language.get("errorImageShare"), {gravity="Center"})
		return
	end

	Share.share{
		url = "https://safebooru.page.link/app",
		image = { {filename=filename, baseDir=baseDir} },
		listener = onShareComplete
	}
end

function M.saveImage()
	local filename, baseDir = view.sliderGetCurrentImage()

	if not filename then
		Toast.show(Language.get("errorImageSave"), {gravity="Center"})
		return
	end

	media.save(filename, baseDir)
	Feedback.show()
	Toast.show(Language.get("saveToGallery"), {gravity="Center"})
end

function M.setWallpaper()
	local filename, baseDir = view.sliderGetCurrentImage()

	if not filename then
		Toast.show(Language.get("wallpaperError"), {gravity="Center"})
		return
	end

	if Wallpaper.isSetWallpaperAllowed() then
		Wallpaper.set(system.pathForFile(filename, baseDir))
		Toast.show(Language.get("wallpaperSet"), {gravity="Center"})
	else
		Toast.show(Language.get("wallpaperError"), {gravity="Center"})
	end
end

function initToolBarButtonsHandle()
	return {
		share = M.shareImage,
		random = M.showRandomImage,
		save = M.saveImage,
		wallpaper = M.setWallpaper,
	}
end

function initHiddenLoading()
	if not networkId then
		if (#view.sliderGetImageList() - view.sliderGetCursor() < 10) then
			hiddenLoading = true
			networkId = KonachanAPI.getImage(downloadImage)
		end
	end
end

function downloadImage(event)
	if errorHandle(event) then
		hiddenLoading = false
		view.sliderMoveToBegin()
		return
	end

	local pool = getImagePool(event.response)
	Loader.download(pool, onLoadingComplete)
end

function getImagePool(response)
	local pool = {}

	for i, item in pairs(response) do
		local url = item.file_url or ""
		local suffix = url:match("%.%a+$")

		if system.canOpenURL(url) and isImage(suffix) then
			local filename = crypto.digest(crypto.md5, url) .. suffix

			if not view.sliderIsAlreadyLoaded(filename) then
				pool[#pool + 1] = {
					url = url,
					filename = filename,
					baseDir = system.TemporaryDirectory,
					optional = true,
				}
			end
		end
	end

	return pool
end

function isImage(suffix)
	local suffix = suffix:lower()
	return (suffix == ".jpg" or suffix == ".png") and true or false
end

function onLoadingComplete(event)
	if event.phase == "ended" and event.status == 200 then
		local filename = event.response.filename
		view.sliderUpdate({[1]=filename})
	end

	if event.isLoaded then
		hideActivityIndicator()

		local files = Loader.getLoadedFiles()

		if #files == 0 then
			Toast.show(Language.get("errorNetworkConnection"), {gravity="Center"})
		    return
		end

		view.sliderCleanCache()

		if view.sliderIsReachLimit() then
			view.sliderCreateImage()
		end

		if not hiddenLoading then
			view.sliderNext()
		end

		networkId = nil
		hiddenLoading = false
	end
end

function showTutorialButtons()
	if Preferences.get("tutorial") == 0 then
		showTutorial()
	end
end

function showTutorialSwipe()
	if Preferences.get("tutorial") == 1 then
		if view.sliderGetCursor() > 0 then
			showTutorial()
		end
	end
end

function showTutorial()
	composer.showOverlay("Overlay.tutorial", { isModal=true, effect="fromLeft", time=400 })
end

function tryShowRandomImage()
	if Preferences.get("tutorial") > 0 then
		M.showRandomImage()
	end
end

function onShareComplete()
	native.setKeyboardFocus(nil)
end

function showActivityIndicator()
	composer.showOverlay("Overlay.loading", {isModal=true})
end

function hideActivityIndicator()
	if composer.getSceneName("overlay") == "Overlay.loading" then
		composer.hideOverlay("fade", 300)
	end
end

function errorHandle(event)
	local errorList = {
		errorNetworkConnection,
		errorResponseType,
		errorEmptyPool,
	}

	for i, error in pairs(errorList) do
		if error(event) then
			hideActivityIndicator()
			return true
		end
	end

	return false
end

function errorNetworkConnection(event)
	if event.isError then
		Toast.show(Language.get("errorNetworkConnection"), {gravity="Center"})
		return true
	end
end

function errorResponseType(event)
	if type(event.response) ~= "table" then
		Toast.show(Language.get("errorResponseType"), {gravity="Center"})
		return true
	end
end

function errorEmptyPool(event)
	local pool = getImagePool(event.response)
	if (#pool == 0) then
		Toast.show(Language.get("errorEmptyPool"), {gravity="Center"})
		return true
	end
end

return M
