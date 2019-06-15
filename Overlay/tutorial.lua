local composer = require "composer"
local scene = composer.newScene()

local TutorialPresenter = require "Presenter.TutorialPresenter"
local TutorialData = require "Model.TutorialData"
local Preferences = require "Preferences"
local Language = require "Language"
local widget = require "widget"

local sceneView

local createInfoPanel
, createItem
, createButton

function scene:create(event)
    sceneView = self.view

    local infoPanel = createInfoPanel(Preferences.get('tutorial'))
    infoPanel:translate(display.contentCenterX, display.contentCenterY)

    sceneView:insert(infoPanel)
end

function scene:hide(event)
    if event.phase == "will" then
        Preferences.save()
    end
end

function createInfoPanel(tutorial)
    local group = display.newGroup()
    group.anchorChildren = true

    for i, params in pairs(TutorialData) do
        if tutorial == params.tutorial then
            local item = createItem(params)
            item.y = (group.height == 0) and 0 or group.height
            group:insert(item)
        end
    end

    local closeButton = createButton(Language.get("tutorial_next"), TutorialPresenter.onNextTouch)
    closeButton.x = group.x
    closeButton.y = group.height
    group:insert(closeButton)

    return group
end

function createItem(params)
    local item = display.newGroup()
    local offset = params.size*0.2
    local fontSize = params.size*0.3
    local fontColor = params.color or {245/255, 245/255, 245/255}

    local panel = display.newRect(item, 0, 0, display.safeActualContentWidth, params.size + offset)
    panel.fill = {158/255, 204/255,	146/255}

    local icon = display.newImageRect(item, params.icon, params.size, params.size)
    icon.x = panel.x - panel.width/2 + icon.width/2 + offset/2
    icon.y = panel.y

    local description = display.newText{
        parent = item,
        text = params.text,
        font = params.font,
        width = panel.width - icon.width - offset,
        fontSize = fontSize,
    }
    description.x = icon.x + icon.width/2 + description.width/2 + offset/2
    description.fill = fontColor

    return item
end

function createButton(label, listener)
    local button = widget.newButton{
        label = label,
        labelColor = { default={1}, over={1} },
        fontSize = 60,
        shape = "roundedRect",
        cornerRadius = 15,
        width = 192,
        height = 96,
        fillColor = { default={235/255, 134/255, 70/255}, over={235/255, 134/255, 70/255} },
        onEvent = listener
    }
    return button
end

scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)

return scene
