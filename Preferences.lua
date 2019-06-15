local M = {}

local json = require "json"

local prefs = {}

local FILENAME = "config.json"
local DIR = system.DocumentsDirectory


function M.init()
    prefs = json.decodeFile(system.pathForFile(FILENAME, DIR)) or {}
    prefs['tutorial'] = prefs['tutorial'] or 0
end

function M.set(key, value)
    prefs[key] = value
end

function M.get(key)
    return prefs[key]
end

function M.save()
	local fh = io.open(system.pathForFile(FILENAME, DIR), "w")

	if fh then
		local encoded = json.encode(prefs, {indent=true})
		fh:write(encoded)

        io.close(fh)
	end
end

return M
