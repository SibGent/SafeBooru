local M = {}

local json = require "json"

local apiListener
, executeListener

local TAGS = "&tags=rating:s+filesize:50kb..5mb"
local API_POSTS = "https://danbooru.donmai.us/posts.json?limit=10&tags=&random=true"


function M.getImage(listener)
	local function getImageListener(event)
		apiListener(event, {
			listener = listener
		})
	end

	network.request(
		API_POSTS .. TAGS,
		"GET",
		getImageListener
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
