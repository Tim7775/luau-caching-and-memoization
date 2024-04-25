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

--- Memoize function calls for a single frame
local function memoizeFrame<K, V>(callback: (K) -> V): (K) -> V
	local scheduledPurge: thread? = nil
	local cache: { [K]: V } = {}

	local function purgeCache()
		scheduledPurge = nil
		cache = {}
	end

	return function(key: K)
		local result = cache[key]
		if result == nil then
			result = callback(key)
			cache[key] = result
			if not scheduledPurge then
				scheduledPurge = task.delay(0, purgeCache)
			end
		end
		return result
	end
end

return memoizeFrame
