local M = {}
local mt = { __index = M }

local onMenuTouch
, expandMenu
, collapseMenu
, onExpandComplete
, onCollapseComplete
, isAnimationStopped
, scaleObject


function M.new(parent, options, onButtonTouch)
    local group = display.newGroup()
    group.x = options.x
    group.y = options.y
    parent:insert(group)

    -- menu button
    local menu = display.newRect(group, 0, 0, options.width, options.height)
    menu.isLocked = false
    menu.isHidden = true
    menu.buttons = {}
    menu.count = 0
    menu.fill = { type="image", filename=options.icon }
    menu.expand = expandMenu
    menu.collapse = collapseMenu
    menu:addEventListener("touch", onMenuTouch)

    -- action button
    for i, item in pairs(options.data) do
        local button = display.newRect(group, 0, 0, options.width, options.width)
        button.xStop = menu.x
        button.yStop = i*(menu.y - button.height)
        button.menu = menu
        button.name = item.name
        button.fill = { type="image", filename=item.image }
        button.isVisible = false
        button:toBack()
        button:addEventListener("touch", onButtonTouch)

        menu.buttons[i] = button
    end

    local self = {
        group = group,
        menu = menu,
    }

    return setmetatable(self, mt)
end


function M:expand()
    if not self.menu.isHidden then
        return
    end

    self.menu.expand(self.menu)
end


function M:collapse()
    if self.menu.isHidden then
        return
    end

    self.menu.collapse(self.menu)
end

-- private
function onMenuTouch(event)
    local menu = event.target
    scaleObject(event, 0.9)

    if event.phase == "ended" then
        if not menu.isLocked then
            menu.isLocked = true

            if menu.isHidden then
                expandMenu(menu)
            else
                collapseMenu(menu)
            end
        end
    end

    return true
end

function expandMenu(menu)
    menu.isHidden = false

    for i, button in pairs(menu.buttons) do
        button.isVisible = true

        local xStop = button.xStop
        local yStop = button.yStop
        transition.to(button, {time=300, x=xStop, y=yStop, xScale=1, yScale=1, onComplete=onExpandComplete})
    end
end

function collapseMenu(menu)
    menu.isHidden = true

    for i, button in pairs(menu.buttons) do
        button.isVisible = true

        local xStop = menu.x
        local yStop = menu.y
        transition.to(button, {time=300, x=xStop, y=yStop, xScale=0.6, yScale=0.6, onComplete=onCollapseComplete})
    end
end

function onExpandComplete(button)
    local menu = button.menu

    if isAnimationStopped(menu) then
        menu.isLocked = false
    end
end

function onCollapseComplete(button)
    local menu = button.menu

    if isAnimationStopped(menu) then
        menu.isLocked = false
    end
end

function isAnimationStopped(menu)
    menu.count = menu.count + 1
    local isStopped = false

    if menu.count == #menu.buttons then
        menu.count = 0
        isStopped = true
    end

    return isStopped
end

function scaleObject(event, scale)
    assert(event, "event is missing")
    local object = event.target
    local scale = scale or 0.95

    if event.phase == "began" then
        object.xScale = scale
        object.yScale = scale
        object.isFocus = true
        display.getCurrentStage():setFocus(object)
    end

    if event.phase == "moved" then
        if event.x > object.contentBounds.xMax - 1
            or event.x < object.contentBounds.xMin + 1
            or event.y < object.contentBounds.yMin + 1
            or event.y > object.contentBounds.yMax - 1 then
                object.xScale = 1
                object.yScale = 1
                object.isFocus = false
        else
            if not object.isFocus then
                object.xScale = scale
                object.yScale = scale
                object.isFocus = true
            end
        end
    end

    if event.phase == "ended" then
        object.xScale = 1
        object.yScale = 1
        display.getCurrentStage():setFocus(nil)
    end

    if not object.isFocus then
        event.phase = nil
    end
end

return M
