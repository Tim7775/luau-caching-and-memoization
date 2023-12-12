--!strict
return function()
	local MultiCache = require(script.Parent)

	local cache: MultiCache.Any
	beforeEach(function()
		cache = MultiCache.new()
	end)

	describe("GetMultiKey", function()
		it("should distinguish nil from void", function()
			local nilKey = cache:GetMultiKey(nil)
			expect(nilKey == nilKey).to.equal(true)
			expect(nilKey == cache:GetMultiKey(nil)).to.equal(true)

			local voidKey = cache:GetMultiKey()
			expect(voidKey == voidKey).to.equal(true)
			expect(voidKey == cache:GetMultiKey()).to.equal(true)

			expect(nilKey == voidKey).to.equal(false)
		end)
		it("should handle keys with trailing nils", function()
			local testKey = cache:GetMultiKey("test")
			expect(testKey == cache:GetMultiKey("test")).to.equal(true)
			local testKeyTrailing = cache:GetMultiKey("test", nil)
			expect(testKeyTrailing == cache:GetMultiKey("test", nil)).to.equal(true)
			expect(testKey == testKeyTrailing).to.equal(false)
		end)
		it("should accept keys consisting of any number of values", function()
			for i = 0, 20 do
				local multiKey, keyComponents = nil, table.create(i, 1)
				expect(function()
					multiKey = cache:GetMultiKey(table.unpack(keyComponents, 1, i))
				end).never.to.throw()
				expect(cache:Has(multiKey)).to.equal(false)
				cache:Set(multiKey, true)
				expect(cache:Get(multiKey)).to.equal(true)
			end
		end)
	end)

	describe("Access", function()
		it("should handle entries set to nil or void", function()
			local nilEntry = cache:GetMultiKey("nil", "entry")
			expect(cache:Has(nilEntry)).to.equal(false)
			expect(function()
				cache:Get(nilEntry)
			end).to.throw()

			cache:Set(nilEntry, nil)
			expect(cache:Has(nilEntry)).to.equal(true)
			expect(select("#", cache:Get(nilEntry))).to.equal(1)

			local voidEntry = cache:GetMultiKey("void", "entry")
			expect(cache:Has(voidEntry)).to.equal(false)
			expect(function()
				cache:Get(voidEntry)
			end).to.throw()

			cache:Set(voidEntry)
			expect(cache:Has(voidEntry)).to.equal(true)
			expect(select("#", cache:Get(voidEntry))).to.equal(0)
		end)
		it("entries should be able to hold any number of values", function()
			local key = cache:GetMultiKey("Key")
			for i = 0, 20 do
				local values = table.create(i, 1)
				expect(function()
					cache:Set(key, table.unpack(values, 1, i))
				end).never.to.throw()
				expect(select("#", cache:Get(key))).to.equal(i)
			end
		end)
	end)
end
