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

export type RRCache<K, V> = {
	Set: (RRCache<K, V>, key: K, value: V) -> (),
	Get: (RRCache<K, V>, key: K) -> V?,
	Has: (RRCache<K, V>, key: K) -> boolean,
	Delete: (RRCache<K, V>, key: K) -> (),
	Clear: (RRCache<K, V>) -> (),
}

--[[
	Random replacement cache
]]
local function new<K, V>(maxSize: number): RRCache<K, V>
	assert(maxSize > 0 and math.floor(maxSize) == maxSize, "invalid maxSize")
	local data: { [K]: V } = {}
	local keys: { K } = table.create(maxSize)
	local size = 0

	local function Delete(_: RRCache<K, V>, key: K)
		if data[key] ~= nil then
			data[key] = nil
			local index = table.find(keys, key) :: number
			keys[index] = keys[size]
			keys[size] = nil
			size -= 1
		end
	end

	local function Set(_: RRCache<K, V>, key: K, value: V)
		if value == nil then
			Delete(nil :: any, key)
		else
			if data[key] == nil then
				if size < maxSize then
					size += 1
					keys[size] = key
				else
					local index = math.random(1, size)
					data[keys[index]] = nil
					keys[index] = key
				end
			end
			data[key] = value
		end
	end

	local function Get(_: RRCache<K, V>, key: K): V?
		return data[key]
	end

	local function Has(_: RRCache<K, V>, key: K): boolean
		return data[key] ~= nil
	end

	local function Clear(_: RRCache<K, V>)
		data = {}
		table.clear(keys)
		size = 0
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
