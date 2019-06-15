local M = {}

local json = require "json"

local data

local getLocale
, getLanguageData
, getFilename
, isFileExists


function M.setLang(locale)
	local lang = getLocale(locale)
	data = getLanguageData(lang)

	if not data then
		error( "Localization file is corrupted" )
	end
end

function M.get(key)
	return data[key] or ( "<" .. key .. ">" )
end

function getLocale(lang)
	local lang = lang or system.getPreference("locale", "language")
	local filename = getFilename(lang)

	if not isFileExists(filename) then
		lang = "en"
	end

	return lang
end

function getLanguageData(lang)
	return json.decodeFile(system.pathForFile(getFilename(lang)))
end

function getFilename(lang)
	return ("Lang/" .. lang .. ".json")
end

function isFileExists(filename, baseDir)
	assert(filename, "filename is missing")
	local pathForFile = system.pathForFile(filename, baseDir) or ""
	local isExists = false

	local fh = io.open(pathForFile, "r")
	if fh then
		isExists = true
		io.close(fh)
	end

	return isExists
end

return M
