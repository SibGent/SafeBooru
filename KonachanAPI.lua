local M = {}

local json = require "json"

local apiListener
, executeListener

local TAGS = "&tags=order:random+mpixels:%3C=2.1+rating:safe"
local API_POSTS = "https://konachan.net/post.json?limit=10"


function M.getImage(listener)
	local function getImageListener(event)
		apiListener(event, {
			listener = listener
		})
	end

	local params = {}
	params.timeout = 3

	return network.request(
		API_POSTS .. TAGS,
		"GET",
		getImageListener,
		params
	)
end

function apiListener(event, params)
	local listener = params.listener

	if event.isError then
		executeListener(listener, {isError=true})

	elseif event.phase == "ended" and event.status == 200 then
        local data = json.decode(event.response)
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
