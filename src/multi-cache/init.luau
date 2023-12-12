--!strict
--[[
	* Copyright (c) 2023 Tim7775
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]

local NIL_SYMBOL = newproxy(true)
getmetatable(NIL_SYMBOL).__tostring = function()
	return "Symbol(nil)"
end

--[[
	**usage:**
	```lua
	local cache = self.cache
	local key = cache:GetMultiKey(...)
	if not cache:Has(key) then
		cache:Set(key, getValuesAsync(...))
	end
	processValues(cache:Get(key))
	self.cache = MultiCache.new() -- clear cache
	```
]]
local function new<K..., V...>(): MultiCache<K..., V...>
	local weakKeys = { __mode = "k" }
	local multiKeyRoot = setmetatable({}, weakKeys)
	local results = setmetatable({}, weakKeys)

	--Returns an identical multi key if it gets called on the same MultiCache with the same arguments
	local function GetMultiKey(_: MultiCache<K..., V...>, ...: K...): MultiKey
		local node = multiKeyRoot
		for i = 1, select("#", ...) do
			local param = select(i, ...)
			if param == nil then
				param = NIL_SYMBOL
			end
			node[param] = node[param] or setmetatable({}, weakKeys)
			node = node[param]
		end
		return node
	end

	local function Set(_: MultiCache<K..., V...>, key: MultiKey, ...: V...)
		assert(getmetatable(key) == weakKeys, "param 'key' must be a key returned by this cache's GetMultiKey() method")
		results[key] = table.pack(...)
	end

	--Returns the value(s) set by the Set() method, throws if Set() has not been called with this key
	local function Get(_: MultiCache<K..., V...>, key: MultiKey): V...
		local result: any = results[key]
		return table.unpack(result, 1, result.n)
	end

	--Returns true if Set() has been called with this key
	local function Has(_: MultiCache<K..., V...>, key: MultiKey): boolean
		return results[key] ~= nil
	end

	return table.freeze({
		Has = Has,
		Get = Get,
		Set = Set,
		GetMultiKey = GetMultiKey,
	})
end

export type MultiKey = typeof(new():GetMultiKey(table.unpack(...)))
export type MultiCache<K..., V...> = {
	Has: (MultiCache<K..., V...>, key: MultiKey) -> boolean,
	Get: (MultiCache<K..., V...>, key: MultiKey) -> V...,
	Set: (MultiCache<K..., V...>, key: MultiKey, V...) -> (),
	GetMultiKey: (MultiCache<K..., V...>, K...) -> MultiKey,
}
export type Any = MultiCache<...any, ...any>

return table.freeze({ new = new })
