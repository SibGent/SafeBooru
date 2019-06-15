local MenuData = {
    android = require "Model.MenuDataAndroid",
    ios = require "Model.MenuDataIos",
}

local platform = system.getInfo("platform")

return MenuData[platform] or MenuData["android"]
