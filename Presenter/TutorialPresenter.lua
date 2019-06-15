local M = {}

local composer = require "composer"
local Preferences = require "Preferences"

local view

function M.init(scene)
    view = scene
end

function M.onNextTouch(event)
    if event.phase == "began" then
        local tutorial = Preferences.get("tutorial") + 1
        Preferences.set("tutorial", tutorial)
        composer.hideOverlay("slideRight", 400)
    end
end

return M
