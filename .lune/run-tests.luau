local pathfs = require("@pkg/pathfs")
local process = require("@lune/process")
local fs = pathfs.fs

type Path = pathfs.Path
type AsPath = pathfs.AsPath

local function forEachFile(dirPath: Path, callback: (filePath: Path, fileName: string) -> ())
	for _, entryName in ipairs(fs.readDir(dirPath)) do
		local entryPath = dirPath:join(entryName)
		if fs.isFile(entryPath) then
			callback(entryPath, entryName)
		else
			forEachFile(entryPath, callback)
		end
	end
end

local function loadTestsFromDirectory(dir: AsPath)
	forEachFile(pathfs.Path.from(dir), function(filePath, fileName)
		if string.match(fileName, "%.test%.luau$") or string.match(fileName, "%.spec%.luau$") then
			local requirePath = "./" .. tostring(pathfs.diff(filePath, pathfs.getDir(true), "/"))
			local module = require(requirePath) :: any
			module()
		end
	end)
end

local function runTests()
	local frktest = require("@pkg/frktest")
	local lune_console_reporter = frktest._reporters.lune_console_reporter

	lune_console_reporter.init()
	return frktest.run()
end

loadTestsFromDirectory("tests")
local allTestsPassed = runTests()
if not allTestsPassed then
	return process.exit(1)
end
