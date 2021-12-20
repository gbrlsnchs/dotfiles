local M = {}

function M:new()
	return setmetatable({ components = {} }, { __index = self })
end

function M:add(component)
	table.insert(self.components, component)

	return self
end

function M:build(statusline_type)
	local is_active = statusline_type == "active"

	local function assemble(component, parts)
		local type = type(parts)

		if type == "string" then
			return component .. parts
		end

		if type == "table" then
			for _, part in ipairs(parts) do
				component = component .. ("%%#%s#%s"):format(part[1], part[2])
			end
			return component
		end

		if type == "function" then
			local parts_result = parts(is_active)
			if not parts_result then
				return nil
			end

			return assemble(component, parts_result)
		end

		return nil
	end

	local sline = ""
	for _, parts in ipairs(self.components) do
		local ok, assembled = pcall(assemble, "", parts)
		if ok and assembled then
			sline = sline .. assembled
		end
	end

	return sline
end

return M
