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

export type HLRUCache<K, V> = {
	Set: (HLRUCache<K, V>, key: K, value: V) -> (),
	Get: (HLRUCache<K, V>, key: K) -> V?,
	Has: (HLRUCache<K, V>, key: K) -> boolean,
	Delete: (HLRUCache<K, V>, key: K) -> (),
	Clear: (HLRUCache<K, V>) -> (),
}

local weakKeys = { __mode = "k" }
--[[
	An LRU cache that is much faster and simpler than the typical doubly linked list LRU cache.
	Based on Dominic Tarr's hashlru algorithmn.

	Cache holds between pageSize and 2*pageSize items
]]
local function new<K, V>(pageSize: number): HLRUCache<K, V>
	assert(pageSize > 0 and math.floor(pageSize) == pageSize, "invalid pageSize")
	local hotCache = setmetatable({}, weakKeys)
	local coldCache = setmetatable({}, weakKeys)
	local size = 0

	local function insert(key: K, value: V)
		hotCache[key] = value
		size += 1
		if size >= pageSize then
			size = 0
			coldCache = hotCache
			hotCache = setmetatable({}, weakKeys)
		end
	end

	local function Has(_: HLRUCache<K, V>, key: K): boolean
		return hotCache[key] ~= nil or coldCache[key] ~= nil
	end

	local function Delete(_: HLRUCache<K, V>, key: K)
		hotCache[key] = nil
		coldCache[key] = nil
	end

	local function Get(_: HLRUCache<K, V>, key: K): V?
		local value = hotCache[key]
		if value ~= nil then
			return value
		end
		value = coldCache[key]
		if value ~= nil then
			insert(key, value)
		end
		return value
	end

	local function Set(_: HLRUCache<K, V>, key: K, value: V)
		if value == nil then
			Delete(nil :: any, key)
		elseif hotCache[key] == nil then
			insert(key, value)
		else
			hotCache[key] = value
		end
	end

	local function Clear(_: HLRUCache<K, V>)
		size = 0
		hotCache = setmetatable({}, weakKeys)
		coldCache = setmetatable({}, weakKeys)
	end

	return table.freeze({
		Set = Set,
		Get = Get,
		Has = Has,
		Delete = Delete,
		Clear = Clear,
	})
end

return table.freeze({ new = new })
