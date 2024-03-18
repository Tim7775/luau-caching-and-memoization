--!nocheck
--# selene: allow(undefined_variable)
local TestEZ = require(game:GetService("TestService").TestEz)
TestEZ.TestBootstrap:run({
	game:GetService("ReplicatedStorage").modules,
})
