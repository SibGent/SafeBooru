local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local platform_list = {"android", "ios"}
local toast = nil
local isInit = false

local isPlatformAllowed


function M.init()
    if isDevice then
        if isPlatformAllowed() then
            isInit = true
            toast = require "plugin.toast"
        end
    end
end

function M.show(text, options)
    if not isInit then
        return
    end

    toast.show(text, options)
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
