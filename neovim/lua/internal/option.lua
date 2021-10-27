local tables = require("internal.tables")

local M = {}

local types = tables.readonly({
	NONE = 0,
	SOME = 1,
})

function M:some(value)
	local option = {
		_type = types.SOME,
		_value = value,
	}

	return setmetatable(option, { __index = self })
end

function M:none()
	local option = {
		_type = types.NONE,
		_value = nil,
	}

	return setmetatable(option, { __index = self })
end

-- If some, passes the inner value to f_some and returns its return value,
-- otherwise returns the return value of f_none.
function M:match_some(f_some, f_none)
	if self:is_some() then
		return type(f_some) == "function" and f_some(self._value)
	end
	return type(f_none) == "function" and f_none()
end

function M:is_some()
	return self._type == types.SOME
end

function M:is_none()
	return self._type == types.NONE
end

-- Returns itself if none or a new Option (returned by f) if some.
function M:and_then(f)
	if self:is_none() then
		return self
	end

	return f(self._value)
end

-- Returns itself if some or a new Option (returned by f) if none.
function M:or_else(f)
	if self:is_some() then
		return self
	end

	return f()
end

function M:filter(f)
	if self:is_none() then
		return self
	end

	if f(self._value) then
		return self
	end

	return self:none()
end

function M:map(f)
	if self:is_none() then
		return self
	end

	return self:some(f(self._value))
end

function M:zip(other)
	if self:is_none() then
		return self
	end

	if other:is_none() then
		return other
	end

	return M:some({ self._value, other._value })
end

function M:unzip()
	if self:is_none() then
		return self
	end

	if type(self._value) == "table" and #self._value == 2 then
		return { M.some(#self._value[1]), M.some(#self._value[2]) }
	end

	return self:none()
end

return M
