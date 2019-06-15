local Feedback = {}


local isInit
local preference


local setOptions
, initFeedback
, canShowFeedback
, onComplete
, openStore
, markFeedbackAsVoted
, closeFeedback
, executeListener


local FEEDBACK_URL = ""
local FEEDBACK_TITLE = "Rate our App"
local FEEDBACK_MESSAGE = "If you like our app, please take a moment to rate it in store!"
local FEEDBACK_POSITIVE = "RATE NOW"
local FEEDBACK_NEGATIVE = "LATER"
local FEEDBACK_FIRST = 86400*7
local FEEDBACK_LATER = 86400*3
local FEEDBACK_ON_AGREE
local FEEDBACK_ON_CANCEL


function Feedback.init(options)
	if not isInit then
		setOptions(options)
		isInit = pcall(initFeedback)
	end
end


function Feedback.show()
	if isInit and canShowFeedback() then
		native.showAlert(FEEDBACK_TITLE, FEEDBACK_MESSAGE, { FEEDBACK_POSITIVE, FEEDBACK_NEGATIVE }, onComplete)
	end
end


function setOptions(options)
	local options = options or {}
	FEEDBACK_URL = options.url or FEEDBACK_URL
	FEEDBACK_TITLE = options.title or FEEDBACK_TITLE
	FEEDBACK_MESSAGE = options.message or FEEDBACK_MESSAGE
	FEEDBACK_POSITIVE = options.positive or FEEDBACK_POSITIVE
	FEEDBACK_NEGATIVE = options.negative or FEEDBACK_NEGATIVE
	FEEDBACK_FIRST = options.first or FEEDBACK_FIRST
	FEEDBACK_LATER = options.later or FEEDBACK_LATER
	FEEDBACK_ON_AGREE = options.onAgree
	FEEDBACK_ON_CANCEL = options.onCancel
end


function initFeedback()
	preference = {
		feedback_is_rated = system.getPreference("app", "feedback_is_rated", "boolean") or false,
		feedback_trigger_time = system.getPreference("app", "feedback_trigger_time", "string") or tostring(os.time() + FEEDBACK_FIRST)
	}
	system.setPreferences("app", preference)
end


function canShowFeedback()
	local currentTime = os.time()
	local triggerTime = tonumber(preference["feedback_trigger_time"])
	local isRated = preference["feedback_is_rated"]
	local canShow = false

	if not isRated and currentTime > triggerTime then
		canShow = true
	end

	return canShow
end


function onComplete(event)
	if event.action == "clicked" then
		if event.index == 1 then
			openStore()
			executeListener(FEEDBACK_ON_AGREE)

		elseif event.index == 2 then
			closeFeedback()
			executeListener(FEEDBACK_ON_CANCEL)

		end

	elseif event.action == "cancelled" then
		closeFeedback()
	end
end


function openStore()
	if system.canOpenURL(FEEDBACK_URL) then
		system.openURL(FEEDBACK_URL)
	end

	markFeedbackAsVoted()
end


function markFeedbackAsVoted()
	preference["feedback_is_rated"] = true
	system.setPreferences("app", preference)
end


function closeFeedback()
	preference["feedback_trigger_time"] = tostring(os.time() + FEEDBACK_LATER)
	system.setPreferences("app", preference)
end


function executeListener(listener)
	if listener then
		listener()
	end
end


return Feedback
