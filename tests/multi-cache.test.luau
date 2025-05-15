local frktest = require("@pkg/frktest")
local test = frktest.test
local check = frktest.assert.check
local req = frktest.assert.require
local msg = frktest.assert.msg

return function()
	local MultiCache = require("@lib/multi-cache")

	local cache: MultiCache.Any
	test.on_test_enter(function()
		cache = MultiCache.new()
	end)

	test.suite("GetMultiKey", function()
		test.case("should distinguish nil from void", function()
			local nilKey = cache:GetMultiKey(nil)
			check.equal(nilKey, nilKey)
			check.equal(nilKey, cache:GetMultiKey(nil))

			local voidKey = cache:GetMultiKey()
			check.equal(voidKey, voidKey)
			check.equal(voidKey, cache:GetMultiKey())

			check.not_equal(nilKey, voidKey)
		end)
		test.case("should handle keys with trailing nils", function()
			local testKey = cache:GetMultiKey("test")
			check.is_true(testKey == cache:GetMultiKey("test"))
			local testKeyTrailing = cache:GetMultiKey("test", nil)
			check.is_true(testKeyTrailing == cache:GetMultiKey("test", nil))
			check.is_false(testKey == testKeyTrailing)
		end)
		test.case("should accept keys consisting of any number of values", function()
			for i = 0, 20 do
				local multiKey, keyComponents = nil, table.create(i, 1)
				req.should_not_errors(function()
					multiKey = cache:GetMultiKey(table.unpack(keyComponents, 1, i))
					return
				end)

				check.is_false(cache:Has(multiKey))
				cache:Set(multiKey, true)
				check.is_true(cache:Has(multiKey))
			end
		end)
	end)

	test.suite("Access", function()
		test.case("should handle entries set to nil or void", function()
			local nilEntry = cache:GetMultiKey("nil", "entry")
			req.is_false(cache:Has(nilEntry))
			check.should_error(function()
				cache:Get(nilEntry)
				return
			end)

			cache:Set(nilEntry, nil)
			req.is_true(cache:Has(nilEntry))
			check.equal(select("#", cache:Get(nilEntry)), 1)

			local voidEntry = cache:GetMultiKey("void", "entry")
			req.is_false(cache:Has(voidEntry))
			check.should_error(function()
				cache:Get(voidEntry)
				return
			end)

			cache:Set(voidEntry)
			req.is_true(cache:Has(voidEntry))
			check.equal(select("#", cache:Get(voidEntry)), 0)
		end)
		test.case("entries should be able to hold any number of values", function()
			local key = cache:GetMultiKey("Key")
			for i = 0, 20 do
				local values = table.create(i, 1)
				req.should_not_errors(function()
					cache:Set(key, table.unpack(values, 1, i))
					return
				end)
				check.equal(select("#", cache:Get(key)), i)
			end
		end)
		test.case(
			"should throw when trying to write to a cache with a multi-key that belongs to a different cache",
			function()
				local unownedKey = MultiCache.new():GetMultiKey("Key")
				check.should_error(function()
					cache:Set(unownedKey, true)
					return
				end, msg("param 'key' must be a key returned by this cache's GetMultiKey() method"))
			end
		)
	end)
end
