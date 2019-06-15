local size = display.actualContentWidth*0.2
local offset = 0.75

local x = size*offset
local y = display.contentHeight - size*offset

return {
    icon = "Assets/menu.png",
    data = {
        { name = "save", image = "Assets/save.png" },
        { name = "share", image = "Assets/share.png" },
        { name = "wallpaper", image = "Assets/wallpaper.png" },
    },
    x = x,
    y = y,
    width = size,
    height = size,
}
