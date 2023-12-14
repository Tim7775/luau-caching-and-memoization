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

export type LRUCache<K, V> = {
	Set: (LRUCache<K, V>, key: K, value: V) -> (),
	Get: (LRUCache<K, V>, key: K) -> V?,
	Has: (LRUCache<K, V>, key: K) -> boolean,
	Peek: (LRUCache<K, V>, key: K) -> V?,
	Delete: (LRUCache<K, V>, key: K) -> (),
	Clear: (LRUCache<K, V>) -> (),
}
type Entry<K, V> = {
	Key: K,
	Value: V,
	Prev: Entry<K, V>?,
	Next: Entry<K, V>?,
}

--[[
	Cache with a least-recently-used cache replacement policy
]]
local function new<K, V>(maxSize: number): LRUCache<K, V>
	assert(maxSize > 0 and math.floor(maxSize) == maxSize, "invalid maxSize")
	local entries: { [K]: Entry<K, V> } = {}
	local newest: Entry<K, V>? = nil
	local oldest: Entry<K, V>? = nil
	local size = 0

	local function cut(entry: Entry<K, V>)
		local prevEntry = entry.Prev
		local nextEntry = entry.Next
		entry.Prev = nil
		entry.Next = nil
		if prevEntry and nextEntry then
			prevEntry.Next = nextEntry
			nextEntry.Prev = prevEntry
		elseif prevEntry then
			-- Cut oldest entry
			prevEntry.Next = nil
			oldest = prevEntry
		elseif nextEntry then
			-- Cut newest entry
			nextEntry.Prev = nil
			newest = nextEntry
		else
			-- Cut the only entry
			newest = nil
			oldest = nil
		end
	end

	local function setNewest(entry: Entry<K, V>)
		if not newest then
			newest = entry
			oldest = entry
		else
			entry.Next = newest
			newest.Prev = entry
			newest = entry
		end
	end

	local function Get(_: LRUCache<K, V>, key: K): V?
		local entry = entries[key]
		if entry == nil then
			return nil
		end
		cut(entry)
		setNewest(entry)
		return entry.Value
	end

	local function Peek(_: LRUCache<K, V>, key: K): V?
		local entry = entries[key]
		return if entry == nil then nil else entry.Value
	end

	local function Has(_: LRUCache<K, V>, key: K): boolean
		return entries[key] ~= nil
	end

	local function Delete(_: LRUCache<K, V>, key: K)
		local entry = entries[key]
		if entry then
			entries[key] = nil
			cut(entry)
			size -= 1
		end
	end

	local function Set(_: LRUCache<K, V>, key: K, value: V)
		if value == nil then
			Delete(nil :: any, key)
		else
			local entry: any = entries[key]
			if entry then
				cut(entry)
			elseif size >= maxSize then
				entry = oldest
				entries[entry.Key] = nil
				cut(entry)
			else
				size += 1
				entry = {}
			end
			entry.Key = key
			entry.Value = value
			entries[key] = entry
			setNewest(entry)
		end
	end

	local function Clear(_: LRUCache<K, V>)
		size = 0
		entries = {}
		newest = nil
		oldest = nil
	end

	return table.freeze({
		Set = Set,
		Get = Get,
		Has = Has,
		Peek = Peek,
		Delete = Delete,
		Clear = Clear,
	})
end

return table.freeze({ new = new })
