local M = {}

local lfs = require "lfs"

function M.fitImage(displayObject, fitWidth, fitHeight, enlarge)
	local scaleFactor = fitHeight/displayObject.height
	local newWidth = displayObject.width*scaleFactor

	if newWidth > fitWidth then
		scaleFactor = fitWidth / displayObject.width
	end

	if not enlarge and scaleFactor > 1 then
		return
	end

	displayObject:scale(scaleFactor, scaleFactor)
end

function M.scaleObject(event, scale)
	assert(event, "event is missing")
	local object = event.target
	local scale = scale or 0.95

	if event.phase == "began" then
		object.xScale = scale
		object.yScale = scale
		object.isFocus = true
		display.getCurrentStage():setFocus(object)
	end

	if event.phase == "moved" then
		if event.x > object.contentBounds.xMax - 1
			or event.x < object.contentBounds.xMin + 1
			or event.y < object.contentBounds.yMin + 1
			or event.y > object.contentBounds.yMax - 1 then
				object.xScale = 1
				object.yScale = 1
				object.isFocus = false
		else
			if not object.isFocus then
				object.xScale = scale
				object.yScale = scale
				object.isFocus = true
			end
		end
	end

	if event.phase == "ended" then
		object.xScale = 1
		object.yScale = 1
		display.getCurrentStage():setFocus(nil)
	end

	if not object.isFocus then
		event.phase = nil
	end
end

function M.isFileExists(filename, baseDir)
	assert(filename, "filename is missing")
	local baseDir = baseDir or system.ResourceDirectory
	local pathForFile = system.pathForFile( filename, baseDir )
	local isExists = false

	if pathForFile then
		local fileHandle = io.open( pathForFile, "r" )

		if fileHandle then
			isExists = true
			io.close(fileHandle)
		end
	end

	return isExists
end

function M.copyFile(srcName, srcPath, dstName, dstPath, overwrite)
	if not M.isFileExists(srcName, srcPath) then
		return
	end

	if not overwrite and M.isFileExists(dstName, dstPath) then
		return
	end

	local rFilePath = system.pathForFile(srcName, srcPath)
	local wFilePath = system.pathForFile(dstName, dstPath)

	local rfh = io.open(rFilePath, "rb")
	local wfh, errorString = io.open(wFilePath, "wb")

	if wfh then
		local data = rfh:read("*a")

		if data then
			if not wfh:write( data ) then
				print( "Write error!" )
				return
			end
		else
			print( "Read error!" )
			return
		end
	else
		print( "File error: " .. errorString )
		return
	end

	rfh:close()
	wfh:close()
end

function M.newFolder(folderName, baseDir)
	assert( folderName, "bad argument #1 to 'newFolder' (string expected, got no value)" )
	local baseDir = baseDir or system.CachesDirectory
	local success = lfs.chdir( system.pathForFile("", baseDir) )

	if success then
		lfs.mkdir(folderName)
	end
end

function M.removeAllFiles(folderName, baseDir, mask)
	local folderName = folderName or ""
	local baseDir = baseDir or system.TemporaryDirectory
	local mask = mask or ".+"

	for filename in lfs.dir( system.pathForFile(folderName, baseDir) ) do
		if filename ~= "." and filename ~= ".." then
			if filename:find(mask) then
				local pathForFile = system.pathForFile(folderName .. "/" .. filename, baseDir)
				os.remove(pathForFile)
			end
		end
	end
end

return M
