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
local function memoizeAsync<K, V>(callback: (K) -> V): (K) -> V
	local resultRegistry = setmetatable({}, weakKeys)
	local threadRegistry = {}

	return function(key: K)
		local result = resultRegistry[key]
		if result == nil then
			local success
			if not threadRegistry[key] then
				threadRegistry[key] = {}
				success, result = pcall(callback, key)
				for _, thread in ipairs(threadRegistry[key]) do
					task.defer(thread, success, result)
				end
				threadRegistry[key] = nil
			else
				table.insert(threadRegistry[key], coroutine.running())
				success, result = coroutine.yield()
			end
			assert(success, result)
			resultRegistry[key] = result
		end
		return result
	end
end

return memoizeAsync
