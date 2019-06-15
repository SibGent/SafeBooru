local M = {}


local thread = {
	id = nil,
	status = "ready",
	queue = nil,
	loaded = nil,
	size = nil,
	listener = nil,
}

local files = {}

local networkListener
, download
, abort
, finalize


function M.download(queue, listener)
	if thread.status == "ready" then
		thread.status = "busy"
		thread.queue = table.copy(queue)
		thread.loaded = {}
		thread.size = #queue
		thread.listener = listener

		download()
	else
		print( "thread is busy" )
	end
end


function M.canLoad(queue)
	local canLoad = true

	if #queue == 0 then
		canLoad = false
	end

	return canLoad
end


function M.stop()
	if thread.id then
		network.cancel(thread.id)
		thread = {status="ready"}
	end
end


function M.getQueueSize()
	return thread["size"] - #thread["queue"], thread["size"]
end


function M.getLoadedFiles()
	return thread["loaded"]
end


function networkListener(event)
	if event.phase == "began" then

	elseif event.phase == "progress" then

	elseif event.phase == "ended" then
		thread.loaded[#thread.loaded + 1] = event.response.filename

		if not thread.queue[1].optional and (event.isError or event.status ~= 200) then
			abort(event)
		else
			if #thread.queue > 1 then
				table.remove(thread.queue, 1)
				download()
			else
				finalize(event)
			end
		end
	end

	if thread.listener then
		thread.listener(event)
	end
end


function download()
	local url = thread.queue[1].url
	local filename = thread.queue[1].filename
	local baseDir = thread.queue[1].baseDir

	local params = {
		progress = true,
		timeout = 10,
	}

	thread.id = network.download( url, "GET", networkListener, params, filename, baseDir )
end


function abort(event)
	event.phase = "abort"
end


function finalize(event)
	event.isLoaded = true
	thread.status = "ready"
end


return M
