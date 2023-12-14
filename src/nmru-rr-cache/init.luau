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

export type NMRURRCache<K, V> = {
	Set: (NMRURRCache<K, V>, key: K, value: V) -> (),
	Get: (NMRURRCache<K, V>, key: K) -> V?,
	Has: (NMRURRCache<K, V>, key: K) -> boolean,
	Peek: (NMRURRCache<K, V>, key: K) -> V?,
	Delete: (NMRURRCache<K, V>, key: K) -> (),
	Clear: (NMRURRCache<K, V>) -> (),
}

--[[
	Not-most-recently-used random replacement cache
]]
local function new<K, V>(maxSize: number): NMRURRCache<K, V>
	assert(maxSize > 1 and math.floor(maxSize) == maxSize, "invalid maxSize")
	local data: { [K]: V } = {}
	local keys: { K } = table.create(maxSize)
	local mruKey: K? = nil
	local size = 0

	local function Delete(_: NMRURRCache<K, V>, key: K)
		if data[key] ~= nil then
			data[key] = nil
			if mruKey == key then
				mruKey = nil
			end
			local index = table.find(keys, key) :: number
			keys[index] = keys[size]
			keys[size] = nil
			size -= 1
		end
	end

	local function Set(_: NMRURRCache<K, V>, key: K, value: V)
		if value == nil then
			Delete(nil :: any, key)
		else
			if data[key] == nil then
				if size < maxSize then
					size += 1
					keys[size] = key
				else
					local index = math.random(1, size)
					local keyToInvalidate = keys[index]
					if keyToInvalidate == mruKey then
						index = if index == size then 1 else index + 1
						keyToInvalidate = keys[index]
					end
					data[keyToInvalidate] = nil
					keys[index] = key
				end
			end
			mruKey = key
			data[key] = value
		end
	end

	local function Get(_: NMRURRCache<K, V>, key: K): V?
		mruKey = key
		return data[key]
	end

	local function Peek(_: NMRURRCache<K, V>, key: K): V?
		return data[key]
	end

	local function Has(_: NMRURRCache<K, V>, key: K): boolean
		return data[key] ~= nil
	end

	local function Clear(_: NMRURRCache<K, V>)
		data = {}
		table.clear(keys)
		mruKey = nil
		size = 0
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
