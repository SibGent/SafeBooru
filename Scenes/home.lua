local composer = require "composer"
local scene = composer.newScene()

local Presenter = require "Presenter.HomePresenter"
local Slider = require "Slider"
local NextButtonData = require "Model.NextButtonData"
local MenuData = require "Model.MenuData"
local Menu = require "Menu"

local sceneView
local backgroundView
local sliderView
local nextButtonView
local menuView

local createBackground
, createSliderView
, createNextButton
, createMenu


function scene:create(event)
	sceneView = self.view
	backgroundView = createBackground()
	sliderView = createSliderView()
	nextButtonView = createNextButton()
	menuView = createMenu()

	Presenter.init(self)
end

function scene:show(event)
	Presenter.show(event)
end

function scene:hide(event)
	Presenter.hide(event)
end

function scene.sliderUpdate(files)
	sliderView:updateImageList(files)
end

function scene.sliderCleanCache()
	sliderView:cleanCache()
end

function scene.sliderCreateImage()
	sliderView:createImage(1)
end

function scene.sliderIsLeftBorder()
	return sliderView:isLeftBorder()
end

function scene.sliderIsRightBorder()
	return sliderView:isRightBorder()
end

function scene.sliderIsLocked()
	return sliderView:isLocked()
end

function scene.sliderIsReachLimit()
	return sliderView:isReachLimit()
end

function scene.sliderNext()
	sliderView:next()
	menuView:collapse()
end

function scene.sliderPrev()
	sliderView:prev()
	menuView:collapse()
end

function scene.sliderMoveToBegin()
	sliderView:moveToBegin()
end

function scene.sliderGetCurrentImage()
	return sliderView:getCurrentImage()
end

function scene.sliderGetCursor()
	return sliderView:getCursor()
end

function scene.sliderGetImageList()
	return sliderView:getImageList()
end

function scene.sliderIsAlreadyLoaded(filename)
	return sliderView:isAlreadyLoaded(filename)
end

function createBackground()
	local background = display.newRect(sceneView, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	background.fill = { 41/255, 44/255, 52/255 }

	return background
end

function createSliderView()
	local margin = {
		top = 0,
		right = 0,
		bottom = NextButtonData.size*1.5,
		left = 0,
	}

	local x = display.screenOriginX + margin.left + ( display.contentWidth - (margin.left + margin.right) )/2
	local y = display.screenOriginY + margin.top + ( display.contentHeight - (margin.top + margin.bottom) )/2
	local width = display.contentWidth - margin.left - margin.right
	local height = display.contentHeight - margin.top - margin.bottom

	local slider = Slider.new({
		parent = sceneView,
		x = x,
		y = y,
		gap = math.ceil(display.actualContentWidth*0.1),
		width = width,
		height = height,
		baseDir = system.TemporaryDirectory,
		time = 300,
		limit = 20,
		onGesture = Presenter.gestureController,
	})
	return slider
end

function createNextButton()
	local name = NextButtonData.name
	local size = NextButtonData.size
	local x = NextButtonData.x
	local y = NextButtonData.y
	local filename = NextButtonData.filename

	local showButton = display.newRect(sceneView, x, y, size, size)
	showButton.name = name
	showButton.fill = { type="image", filename=filename }
	showButton:addEventListener("touch", Presenter.toolBarController)

	return showButton
end

function createMenu()
	local menu = Menu.new(sceneView, MenuData, Presenter.toolBarController)
	return menu
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
