local process = require("@lune/process")

function load_tests()
	require("./multi-cache.test.luau")()
end

function run_tests()
	local frktest = require("@pkg/frktest")
	local lune_console_reporter = frktest._reporters.lune_console_reporter

	lune_console_reporter.init()
	return frktest.run()
end

load_tests()
local passedAllTests = run_tests()
if not passedAllTests then
	return process.exit(1)
end
