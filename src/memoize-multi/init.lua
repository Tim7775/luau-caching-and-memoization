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

local function memoizeMulti<P..., R...>(callback: (P...) -> R...): (P...) -> R...
	local multiKeyRoot = setmetatable({}, weakKeys)
	local resultRegistry = setmetatable({}, weakKeys)
	return function(...: P...)
		local key = getMultiKey(multiKeyRoot, ...)
		local result = resultRegistry[key]
		if not result then
			result = table.pack(callback(...))
			resultRegistry[key] = result
		end
		return table.unpack(result, 1, result.n)
	end
end

return memoizeMulti
