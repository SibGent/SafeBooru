local Resources = require "Resources"
local Language = require "Language"

local TutorialData = {
    { icon = Resources.random, text = Language.get("tutorial_loadImage"), font=Resources.font_regular, size  = 144, tutorial = 0 },
    { icon = Resources.menu, text   = Language.get("tutorial_menuImage"), font=Resources.font_regular, size  = 144, tutorial = 0 },
    { icon = Resources.swipe_left, text  = Language.get("tutorial_swipeLeft"), font=Resources.font_regular, size = 144, tutorial = 1 },
    { icon = Resources.swipe_right, text  = Language.get("tutorial_swipeRight"), font=Resources.font_regular, size = 144, tutorial = 1 },
}

return TutorialData
