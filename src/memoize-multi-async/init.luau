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

local weakKeys = { __mode = "k" }
local function getMultiKey(node, ...)
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

local function packResult(success, ...): (boolean, { any })
	return success, table.pack(...)
end

--- Memoize async function calls with multiple parameters and return values
local function memoizeMultiAsync<P..., R...>(callback: Callback<P..., R...>): Callback<P..., R...>
	local multiKeyRoot = setmetatable({}, weakKeys)
	local resultRegistry = setmetatable({}, weakKeys)
	local threadRegistry = {}

	return function(...: P...)
		local key = getMultiKey(multiKeyRoot, ...)
		local result = resultRegistry[key]
		if not result then
			local success
			if not threadRegistry[key] then
				threadRegistry[key] = {}
				success, result = packResult(pcall(callback, ...))
				for _, thread in ipairs(threadRegistry[key]) do
					task.defer(thread, success, result)
				end
				threadRegistry[key] = nil
			else
				table.insert(threadRegistry[key], coroutine.running())
				success, result = coroutine.yield()
			end
			assert(success, result[1])
			resultRegistry[key] = result
		end
		return table.unpack(result, 1, result.n)
	end
end

type Callback<P..., R...> = (P...) -> R...
return memoizeMultiAsync
