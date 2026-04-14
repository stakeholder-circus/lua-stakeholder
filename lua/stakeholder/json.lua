local M = {}

local function escape_string(value)
	local replacements = {
		["\\"] = "\\\\",
		['"'] = '\\"',
		["\b"] = "\\b",
		["\f"] = "\\f",
		["\n"] = "\\n",
		["\r"] = "\\r",
		["\t"] = "\\t",
	}

	return value:gsub('[%z\1-\31\\"]', function(char)
		return replacements[char] or string.format("\\u%04x", char:byte())
	end)
end

local function is_array(value)
	if type(value) ~= "table" then
		return false
	end

	local count = 0
	for key, _ in pairs(value) do
		if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then
			return false
		end
		count = count + 1
	end

	for index = 1, count do
		if value[index] == nil then
			return false
		end
	end

	return true
end

local function sorted_keys(value)
	local keys = {}
	for key, _ in pairs(value) do
		keys[#keys + 1] = key
	end
	table.sort(keys)
	return keys
end

local function encode(value)
	local value_type = type(value)

	if value == nil then
		return "null"
	end

	if value_type == "boolean" then
		return value and "true" or "false"
	end

	if value_type == "number" then
		return string.format("%.14g", value)
	end

	if value_type == "string" then
		return '"' .. escape_string(value) .. '"'
	end

	if value_type ~= "table" then
		error("unsupported json type: " .. value_type)
	end

	if is_array(value) then
		local parts = {}
		for index = 1, #value do
			parts[#parts + 1] = encode(value[index])
		end
		return "[" .. table.concat(parts, ",") .. "]"
	end

	local parts = {}
	for _, key in ipairs(sorted_keys(value)) do
		parts[#parts + 1] = encode(tostring(key)) .. ":" .. encode(value[key])
	end
	return "{" .. table.concat(parts, ",") .. "}"
end

M.encode = encode

return M
