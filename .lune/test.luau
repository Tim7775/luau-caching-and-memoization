local fs = require("@lune/fs")
local process = require("@lune/process")
local color = require("@lune/stdio").color

--Install wally packages
if not fs.isDir("test/Packages") then
	local result = process.spawn("wally", { "install" }, { cwd = process.cwd .. "/" .. "test" })
	local output = string.gsub(result.stderr, "\n$", "")
	if not result.ok then
		print(color("red") .. "An error occured while installing wally packages")
		print(output .. color("reset"))
		process.exit(1)
	end
	print(color("blue") .. output .. color("reset"))
end

--Build roblox place
local result = process.spawn("rojo", {
	"build",
	"default.project.json",
	"-o",
	"test/test.rbxl",
})
if not result.ok then
	print(color("red") .. "An error occured during rojo build")
	print(result.stderr .. color("reset"))
	process.exit(1)
end
print(color("blue") .. string.gsub(result.stdout, "\n$", "") .. color("reset"))

--Run tests
result = process.spawn("run-in-roblox", {
	"--place",
	"test/test.rbxl",
	"--script",
	"test/run.server.luau",
})
local output = string.gsub(result.stdout, "\n$", "")
if result.ok then
	print(color("green") .. output .. color("reset"))
else
	print(color("red") .. output .. color("reset"))
end
