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

local weakKeys = { __mode = "k" }
local function memoizeRecentlyUsed<K, V>(n: number, callback: (K) -> V): (K) -> V
	assert(n >= 1, "param 'n' must be >= 1")
	local hotCache = setmetatable({}, weakKeys)
	local coldCache = setmetatable({}, weakKeys)
	local size = 0

	return function(key: K)
		local value = hotCache[key]
		if value ~= nil then
			return value
		end
		value = coldCache[key]
		if value == nil then
			value = callback(key)
		end
		hotCache[key] = value
		size += 1
		if size > n then
			size = 0
			coldCache = hotCache
			hotCache = setmetatable({}, weakKeys)
		end
		return value
	end
end

return memoizeRecentlyUsed
