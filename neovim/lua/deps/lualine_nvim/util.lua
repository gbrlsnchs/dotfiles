local tables = require("util.tables")

local M = {}

M.sections = tables.readonly({
	"lualine_a",
	"lualine_b",
	"lualine_c",
	"lualine_x",
	"lualine_y",
	"lualine_z",
})

M.custom_sections = {}

function M.register_section(section, fn)
	table.insert(M.custom_sections, { name = section, component = fn })
end

return M
