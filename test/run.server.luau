--!nocheck
local TestEZ = require(game:GetService("TestService").Packages.TestEZ)
TestEZ.TestBootstrap:run({
	game:GetService("ReplicatedStorage").modules,
})
