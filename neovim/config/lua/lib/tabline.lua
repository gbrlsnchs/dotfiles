local util = require("lib.win")

local Builder = require("lib.statusline.builder")

local api = vim.api

local M = {}

local tabline_builder = Builder:new():add(function(is_active)
	if not is_active then
		return
	end

	local ft = api.nvim_buf_get_option(0, "filetype")
	local lsp_clients = vim.tbl_filter(function(client)
		return vim.tbl_contains(client.config.filetypes, ft)
	end, vim.lsp.get_active_clients())

	if #lsp_clients == 0 then
		return
	end

	local client_names = {}
	for _, client in ipairs(lsp_clients) do
		table.insert(client_names, client.name)
	end

	table.sort(client_names, function(a, b)
		return a < b
	end)

	client_names = table.concat(client_names, ", ")
	client_names = (" %s "):format(client_names)

	local severity = vim.diagnostic.severity
	local diagnostic_count = {
		[severity.ERROR] = 0,
		[severity.WARN] = 0,
		[severity.INFO] = 0,
		[severity.HINT] = 0,
	}
	local buf_diagnostics = vim.diagnostic.get(0)
	for _, diagnostic in ipairs(buf_diagnostics) do
		diagnostic_count[diagnostic.severity] = diagnostic_count[diagnostic.severity] + 1
	end

	local function get_sign(name)
		local signs = vim.fn.sign_getdefined(name)
		local text = signs[1].text

		return text:sub(1, -2)
	end

	local signs = {
		error = get_sign("DiagnosticSignError"),
		warn = get_sign("DiagnosticSignWarn"),
		info = get_sign("DiagnosticSignInfo"),
		hint = get_sign("DiagnosticSignHint"),
	}

	return {
		{ "StatusLineActive", "%=" },
		{ "StatusLineLSPServer", client_names },
		{
			"StatusLineLSPError",
			(" %s: %d "):format(signs.error, diagnostic_count[severity.ERROR]),
		},
		{
			"StatusLineLSPWarn",
			(" %s: %d "):format(signs.warn, diagnostic_count[severity.WARN]),
		},
		{
			"StatusLineLSPInfo",
			(" %s: %d "):format(signs.info, diagnostic_count[severity.INFO]),
		},
		{
			"StatusLineLSPHint",
			(" %s: %d "):format(signs.hint, diagnostic_count[severity.HINT]),
		},
	}
end)

function M.build_statusline()
	local current_win = api.nvim_get_current_win()
	local focused_win = util.get_focused_win()
	local statusline_type = current_win == focused_win and "active" or "inactive"

	return tabline_builder:build(statusline_type)
end

return M
