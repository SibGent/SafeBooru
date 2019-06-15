local composer = require "composer"
local scene = composer.newScene()

local Language = require "Language"
local Resources = require "Resources"

local sceneView

local imageSheet = graphics.newImageSheet(Resources.anim_loading, {
    numFrames          = 12,
    width              = 500,
    height             = 500,
    sheetContentWidth  = 2000,
    sheetContentHeight = 1500,
})

local sequenceData = {
    name          = "loading",
    start         = 1,
    count         = 12,
    time          = 1440,
    loopCount     = 0,
    loopDirection = "bounce"
}

local CCX = display.contentCenterX
local CCY = display.contentCenterY
local ACW = display.contentWidth
local ACH = display.contentHeight

function scene:create(event)
    sceneView = self.view

    local background = display.newRect(CCX, CCY, ACW, ACH)
    background.fill = {0, 0, 0, 0.65}

    local animation = display.newSprite(imageSheet, sequenceData)
    local animation_scale = ACW*0.6/animation.width
    animation.x = CCX
    animation.y = CCY
    animation:scale(animation_scale, animation_scale)
    animation:play()

    local width = animation.width*animation.xScale
    local height = animation.height*animation.yScale
    local round = width*0.05

    local panel = display.newRoundedRect(0, 0, width, height, round)
    panel.x = animation.x
    panel.y = animation.y
    panel.fill = {220/255, 220/255, 220/255}

    local label = display.newText({
        text = Language.get("loading"),
        font = Resources.font_bold,
        fontSize = panel.width*0.12,
    })
    label.x = panel.x
    label.y = panel.y + panel.height/2 + label.height/1.5

    sceneView:insert(background)
    sceneView:insert(panel)
    sceneView:insert(animation)
    sceneView:insert(label)
end


function scene:show(event)

end


function scene:hide(event)

end


function scene:destroy(event)

end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)


return scene
