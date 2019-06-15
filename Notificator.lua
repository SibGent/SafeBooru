local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local platform_list = {"android", "ios"}
local OneSignal = nil
local isInit = false

local isPlatformAllowed


function M.init(appId, googleProjectNumber, DidReceiveRemoteNotificationCallBack)
    if isDevice then
        if isPlatformAllowed() then
            OneSignal = require "plugin.OneSignal"
            isInit = pcall(OneSignal.Init, appId, googleProjectNumber, DidReceiveRemoteNotificationCallBack)
        end
	end
end


function M.enableNotificationsWhenActive(status)
    if not isInit then
        return
    end

    OneSignal.EnableNotificationsWhenActive(status)
end


function M.enableInAppAlertNotification(status)
    if not isInit then
        return
    end

    OneSignal.EnableInAppAlertNotification(status)
end


function M.setSubscription(status)
    if not isInit then
        return
    end

    OneSignal.SetSubscription(status)
end


function M.enableSound(status)
    if not isInit then
        return
    end

    OneSignal.EnableSound(status)
end


function M.enableVibrate(status)
    if not isInit then
        return
    end

    OneSignal.EnableVibrate(status)
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
