local M = {}

function M.fadeIn(object)
	return transition.from(object, {time=300, alpha=0})
end

function M.zoomOutInFade(object)
	return transition.from(object, {time=300, xScale=0.1, yScale=0.1, alpha=0})
end

function M.moveToX(object, x, listener)
	return transition.to(object, {time=300, x=x, onComplete=listener})
end

function M.moveToCenter(object, listener)
	return transition.to(object, {time=300, x=display.contentCenterX, onComplete=listener})
end

function M.moveToBegin(object, listener)
	return transition.to(object, {time=300, x=object.xBegin, onComplete=listener})
end

function M.stop(object)
	transition.cancel(object)
end

return M
