local M = {}


local platform = system.getInfo("platform")
local hasFacebook
local hasTwitter
local hasWeibo


local canShowShareDialog
, showShareDialog
, showPopup
, getSocialButtons


function M.share(params)
	if canShowShareDialog() then
		showShareDialog(params)
	end
end


function canShowShareDialog()
	local isAvailable = false

	if platform == "android" then
		isAvailable = native.canShowPopup("social", "share")

	elseif platform == "ios" then
		hasFacebook = native.canShowPopup("social", "facebook")
		hasTwitter = native.canShowPopup("social", "twitter")
		hasWeibo = native.canShowPopup("social", "sinaWeibo")

		if hasFacebook or hasTwitter or hasWeibo then
			isAvailable = true
		end
	end

	return isAvailable
end


function showShareDialog(params)
	if platform == "android" then
		showPopup("share", params)

	elseif platform == "ios" then
		local socialButtons = getSocialButtons(hasFacebook, hasTwitter, hasWeibo)

		native.showAlert("Поделиться картинкой", "Выберите приложение, в котором хотите поделитья картинкой.", socialButtons, function(event)
			if event.action == "clicked" then
				local index = event.index

				if index < #socialButtons then
					local serviceName = socialButtons[index]
					showPopup(serviceName, params)
				end
			end
		end)
	end
end


function showPopup(serviceName, params)
	local params = params or {}

	native.showPopup("social", {
		service = serviceName,
		message = params.message,
		image = params.image,
		url = params.url,
		listener = params.listener,
	})
end


function getSocialButtons(hasFacebook, hasTwitter, hasWeibo)
	local socialButtons = {}

	if hasFacebook then
		table.insert(socialButtons, "facebook")
	end

	if hasTwitter then
		table.insert(socialButtons, "twitter")
	end

	if hasWeibo then
		table.insert(socialButtons, "sinaWeibo")
	end

	table.insert(socialButtons, "cancel")

	return socialButtons
end


return M
