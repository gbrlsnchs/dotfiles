local None = require("local.std.none")
local tables = require("internal.tables")

local M = {}

M.types = tables.readonly({
	OK = 0,
	ERR = 1,
})

function M:match(f)
	f(self.value, self.err)
end

function M:is_ok()
	return self.type == M.types.OK
end

function M:and_then(f)
	if not self:is_ok() then
		return None
	end

	return f(self.value)
end

function M:or_else(f)
	return f()
end

return M
