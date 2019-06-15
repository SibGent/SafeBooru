local M = {}
local mt = { __index = M }

local mAbs = math.abs

local createImage
, moveTo
, updateStack
, isUpdateStackPause
, removeOutborderImage
, createOutborderImage
, updateBeginPoints
, resetVariables
, fitImage


function M.new(options)
    local self = {
        parent = options.parent,
        group = display.newGroup(),
        x = options.x,
        y = options.y,
        gap = options.gap,
        width = options.width,
        height = options.height,
        baseDir = options.baseDir,
        time = options.time,
        limit = options.limit,
        imageList = {},
        imageHistory = {},
        stack = {},
        cursor = 0,
        max = 3,
        dir = 0,
        count = 0,
        tick = 0,
        lock = false,
        onGesture = options.onGesture
    }
    self.parent:insert(self.group)

    local newInstance = setmetatable(self, mt)
    Runtime:addEventListener("enterFrame", newInstance)

    return newInstance
end


function M:destroy()
    Runtime:removeEventListener("enterFrame", self)

    for i = #self.stack, 1, -1 do
        self.stack[i]:removeSelf()
        self.stack[i] = nil
    end
end


function M:updateImageList(files)
    for i = 1, #files do
        local filename = files[i]
        self.imageList[1 + #self.imageList] = filename
        self.imageHistory[filename] = true
    end
end


function M:cleanCache()
    if self.cursor > self.limit then
        for i = self.limit, 1, -1 do
            local pathForFile = system.pathForFile(self.imageList[i], self.baseDir)
            os.remove(pathForFile)
            table.remove(self.imageList, i)
        end

        self.cursor = self.cursor - self.limit
    end
end


function M:createImage(dir)
    local pos = (dir > 0) and #self.stack + 1 or 1
    local cur = (dir > 0) and self.cursor + 1 or self.cursor - 1

    local image = display.newImage(self.group, self.imageList[cur], self.baseDir, 0, 0)
    fitImage(image, self.width, self.height, true)
    image.x = self.x + (self.width + self.gap)*dir
    image.y = self.y
    image.xBegin = image.x
    image.stack = self.stack
    table.insert(self.stack, pos, image)

    if self.onGesture then
        image:addEventListener("touch", self.onGesture)
    end

    return image
end


function M:isLeftBorder()
    return (self.cursor == 1) and true or false
end


function M:isRightBorder()
    return (self.cursor == #self.imageList) and true or false
end


function M:isLocked()
    return self.lock
end


function M:isReachLimit()
    return (self.stack[3]==nil) and true or false
end


function M:isAlreadyLoaded(filename)
    local isLoaded = (self.imageHistory[filename]) and true or false
    return isLoaded
end


function M:next()
    if self.lock then
        return
    end

    if self.cursor == #self.imageList then
        return
    end

    moveTo(self, 1)
end


function M:prev()
    if self.lock then
        return
    end

    if self.cursor == 1 then
        return
    end

    moveTo(self, -1)
end


function M:moveToBegin()
    for i = 1, #self.stack do
        self.stack[i].x = self.stack[i].xBegin
    end
end


function M:getCurrentImage()
    return self.imageList[self.cursor], self.baseDir
end


function M:getCursor()
    return self.cursor
end


function M:getImageList()
    return self.imageList
end


function M:enterFrame()
    if self.lock then

        for i = 1, #self.stack do
            local image = self.stack[i]

            if self.dir == -1 then
                if image.x - image.speed < image.xStop then
                    image.speed = -(image.xStop - image.x)
                end

                image:translate(-image.speed, 0)

                if image.x == image.xStop then
                    updateStack(self)
                end
            end


            if self.dir == 1 then
                if image.x + image.speed > image.xStop then
                    image.speed = image.xStop - image.x
                end

                image:translate(image.speed, 0)

                if image.x == image.xStop then
                    updateStack(self)
                end
            end

        end
    end
end


-- private --
function moveTo(self, dir)
    self.dir = -dir

    for i = 1, #self.stack do
        local image = self.stack[i]
        image.xStop = image.xBegin - (self.width + self.gap)*dir
        image.speed = mAbs(image.xBegin - image.xStop)/(display.fps*self.time/1000)
    end

    self.lock = true
end

function updateStack(self)
    if self.count == #self.stack then
        if isUpdateStackPause(self) then
            return
        end

        removeOutborderImage(self)
        createOutborderImage(self)
        updateBeginPoints(self)
        resetVariables(self)
    else
        self.count = self.count + 1
    end
end

function isUpdateStackPause(self)
    self.tick = self.tick + 1

    if self.tick > 30 then
        return false
    end

    return true
end

function removeOutborderImage(self)
    if #self.stack == self.max then
        local pos = (self.dir > 0) and #self.stack or 1
        self.stack[pos]:removeSelf()
        self.stack[pos] = nil
        table.remove(self.stack, pos)
    end
end

function createOutborderImage(self)
    self.cursor = (self.dir < 0) and self.cursor + 1 or self.cursor - 1

    if (self.dir < 0 and self.cursor < #self.imageList) or (self.dir > 0 and self.cursor - 1 > 0) then
        self:createImage(-self.dir)
    end
end

function updateBeginPoints(self)
    for i = 1, #self.stack do
        self.stack[i].xBegin = self.stack[i].x
    end
end

function resetVariables(self)
    self.dir = 0
    self.count = 0
    self.tick = 0
    self.lock = false
end

function fitImage(object, fitWidth, fitHeight, enlarge)
	local scaleFactor = fitHeight/object.height
	local newWidth = object.width*scaleFactor

	if newWidth > fitWidth then
		scaleFactor = fitWidth / object.width
	end

	if not enlarge and scaleFactor > 1 then
		return
	end

	object.width = object.width*scaleFactor
	object.height = object.height*scaleFactor
end


return M
