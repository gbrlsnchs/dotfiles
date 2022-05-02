local M = {}

local err_msgs = {}

--- Creates a new line builder.
--- @param hl_prefix string: The prefix to be used for highlight groups.
--- @return table: Line builder.
function M:new(hl_prefix)
	return setmetatable({
		hl_prefix = hl_prefix,
		components = {}
	}, { __index = self })
end

--- Adds a new component to the line.
--- @return table: Reference to the line builder.
function M:add(component)
	table.insert(self.components, component)

	return self
end

--- Builds components for the line conditionally.
--- @param is_focused boolean: Whether the current window is focused.
--- @return string: String representation of the line.
function M:build(is_focused)
	local component = ""

	--- Assembles bar components into their string representation.
	--- @param parts any: One piece of a bar.
	local function assemble(parts)
		if not parts then
			return
		end

		local type = type(parts)

		if type == "string" then
			component = component .. parts
		elseif type == "table" then
			if vim.tbl_islist(parts) then
				for _, part in ipairs(parts) do
					assemble(part)
				end
			else
				component = component .. "%#" .. self.hl_prefix .. parts.hl .. "#" .. (parts.content or "")
			end
		elseif type == "function" then
			assemble(parts(is_focused))
		end
	end

	for idx, parts in ipairs(self.components) do
		local ok, err = pcall(assemble, parts)
		if not ok then
			-- Only log this specific error once, since bars get rendered continuously.
			local msg = string.format("Could not load component #%d for bar %q: %s", idx, self.hl_prefix, err)

			if not err_msgs[msg] then
				err_msgs[msg] = true
				vim.notify(msg, vim.log.levels.ERROR)
			end
		end
	end

	return component
end

return M
