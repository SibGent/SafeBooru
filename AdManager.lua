local AdManager = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local platform_list = {"android", "ios"}
local appodeal = nil
local isInit = false
local isBannerShown = false

local isPlatformAllowed
, getAppKey
, adListener


function AdManager.init(options)
    if isDevice then
        if isPlatformAllowed() then
            options.appKey = getAppKey(options)

            appodeal = require "plugin.appodeal"
            appodeal.init(adListener, options)
        end
    end
end

function AdManager.isLoaded(adUnitType)
    if not isInit then
        return
    end

    return appodeal.isLoaded(adUnitType)
end

function AdManager.showBanner(position)
    if not isInit then
        return
    end

    appodeal.show("banner", {yAlign=position})
end

function AdManager.showInterstitial()
    if not isInit then
        return
    end

    appodeal.show("interstitial")
end

function AdManager.canShowBanner()
    return (isInit and not isBannerShown) and true or false
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

function getAppKey(options)
    local appKey = options[platform] or ""
    options.android = nil
    options.ios = nil

    return appKey
end

function adListener(event)
    if event.phase == "init" then
        isInit = true
    end

    if event.type == "banner" then
        if event.phase == "displayed" then
            isBannerShown = true
        end

        if event.phase == "hidden" then
            isBannerShown = false
        end
    end
end

return AdManager
