local NetLib = {}

local socket = require "socket"

local HOST = "208.67.222.222"
local PORT = 53
local TIMEOUT = 1

function NetLib.hasConnection()
	local hasConnection = true

	local tcp = assert(socket.tcp())
	tcp:settimeout(TIMEOUT, 't')

	local receive, errorMessage = tcp:connect(HOST, PORT)

	if not receive then
		hasConnection = false
	end

	tcp:close()
	tcp = nil

	return hasConnection
end

return NetLib