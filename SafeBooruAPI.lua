local M = {}

local XML = require ("Libs.XML").newParser()

local apiListener
, executeListener

local API_COUNT = "https://safebooru.org/index.php?page=dapi&s=post&q=index&pid=1&limit=0"
local API_IMAGE = "https://safebooru.org/index.php?page=dapi&s=post&q=index&limit=1&id="

function M.getImageCount(listener)
	local function getImageCountListener(event)
		apiListener(event, {
			listener = listener
		})
	end

	network.request(
		API_COUNT,
		"GET",
		getImageCountListener
	)
end

function M.getImage(id, listener)
	local function getImageListener(event)
		apiListener(event, {
			listener = listener
		})
	end

	network.request(
		API_IMAGE .. id,
		"GET",
		getImageListener
	)
end

function apiListener(event, params)
	local listener = params.listener

	if event.isError then
		executeListener(listener, {isError=true})

	elseif event.phase == "ended" and event.status == 200 then
		local data = XML:ParseArgs(event.response)
		executeListener(listener, {isError=false, response=data})

	else
		executeListener(listener, {isError=true})
	end
end

function executeListener(listener, params)
	if listener then
		listener(params)
	end
end

return M
