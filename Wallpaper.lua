local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local platform_list = {"android"}
local wallpaper = nil
local isInit = false

local isPlatformAllowed


function M.init()
    if isDevice then
        if isPlatformAllowed() then
            isInit = true
            wallpaper = require "plugin.wallpaper"
        end
    end
end

function M.isSetWallpaperAllowed()
    if not isInit then
        return false
    end

    return wallpaper.isSetWallpaperAllowed()
end

function M.set(pathForFile)
    if not isInit then
        return
    end

    wallpaper.set(pathForFile)
end

function isPlatformAllowed()
    local isAllowed = false

    for i = 1, #platform_list do
        if platform == platform_list[i] then
            isAllowed = true
            break
        end
    end

    return isAllowed
end

return M
