require "Libs.Table"

display.setStatusBar(display.HiddenStatusBar)

local Preferences = require "Preferences"
Preferences.init()

local Language = require "Language"
Language.setLang()

local Toast = require "Toast"
Toast.init()

local Wallpaper = require "Wallpaper"
Wallpaper.init()

local composer = require "composer"
composer.gotoScene("Scenes.home")

local Utility = require "Libs.Utility"

local Feedback = require "Libs.Feedback"
Feedback.init({
    url = "https://safebooru.page.link/feedback",
    title = Language.get("feedbackTitle"),
    message = Language.get("feedbackMessage"),
    positive = Language.get("feedbackPositive"),
    negative = Language.get("feedbackNegative"),
    first = 86400*3,
    later = 86400*7,
})

Runtime:addEventListener("system", function(event)
    if event.type == "applicationStart" then
        Utility.removeAllFiles(nil, system.TemporaryDirectory)
    end
end)
