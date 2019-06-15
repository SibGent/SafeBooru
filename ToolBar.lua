local M = {}


function M.new(parent, data, listener)
	local container = display.newContainer(parent, display.contentWidth, 144)
	container.x = display.contentCenterX
	container.y = display.contentHeight - container.height/2

	local self = {
		left = -container.width/2,
		center = 0,
		right = container.width/2,
	}

	local background = display.newRect(container, 0, 0, container.width, container.height)
	background.fill = {158/255, 204/255, 146/255}

	for i, item in pairs(data) do
		local button = display.newRect(self[item.align], 0, item.size, item.size)
		button.name = item.name
		button.fill = item.image
		button:addEventListener("touch", listener)

		if item.align == "left" then
			button.x = button.x + button.width/1.5
		elseif item.align == "right" then
			button.x = button.x - button.width/1.5
		end

		container:insert(button)
	end

	local self = {
		height = container.height,
	}

	return setmetatable(self, { __index = M })
end


return M
