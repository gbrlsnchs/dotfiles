local api = vim.api

local keys = {
	esc = "",
	enter = "\n",
}

local macros_per_ft = {}

local macros = {
	go = {
		e = {
			"o",
			"if err != nil {",
			keys.enter,
			keys.enter,
			"}",
			keys.esc,
			"==",
			"k",
			"S",
		},
	},
	rust = {
		o = {
			"o",
			"Ok(())",
			keys.esc,
		},
	},
}

for _, macro_list in pairs(macros) do
	for reg, macro in pairs(macro_list) do
		macro_list[reg] = table.concat(macro, "")
	end
end

local M = {}

function M.set_macros()
	local bufnr = api.nvim_get_current_buf()
	local ft = api.nvim_buf_get_option(bufnr, "ft")

	for buffer_ft, buffer_macros in pairs(macros_per_ft) do
		if buffer_ft and buffer_ft ~= ft then
			for _, reg in ipairs(buffer_macros) do
				vim.fn.setreg(reg, "")
			end

			macros_per_ft[buffer_ft] = nil
		end
	end

	if macros_per_ft[ft] then
		return
	end

	local macro_list = macros[ft]

	if not macro_list then
		return
	end

	if not macros_per_ft[ft] then
		macros_per_ft[ft] = {}
	end

	for reg, macro in pairs(macro_list) do
		vim.fn.setreg(reg, macro)
		table.insert(macros_per_ft[ft], reg)
	end
end

return M
