local util = require("lib.win")

local Builder = require("lib.statusline.builder")

local api = vim.api
local cwd = vim.loop.cwd()

local M = {}

local sline_bd = Builder
	:new()
	:add(function(is_active)
		local hl = (is_active and "StatusLineActive") or "StatusLineInactive"
		local fillchars = vim.opt.fillchars:get()

		return { { hl, fillchars.eob .. " " } }
	end)
	:add(function(is_active)
		local hl = is_active and "StatusLineActive" or "StatusLineInactive"

		if vim.bo.modified then
			return { { hl .. "FileInfoModified", "%f" } }
		end

		return { { hl .. "FileInfo", "%f" } }
	end)
	:add(function(is_active)
		local hl = is_active and "StatusLineActive" or "StatusLineInactive"

		return { { hl, " " } }
	end)
	:add(function(is_active)
		local branch = vim.b.gitsigns_head

		return is_active and branch and { { "StatusLineBranch", (" %s "):format(branch) } }
	end)
	:add(function(is_active)
		local status = vim.b.gitsigns_status_dict

		return is_active
			and status
			and {
				{ "StatusLineDiffAdd", (" +%d "):format(status.added or 0) },
				{ "StatusLineDiffChange", (" ~%d "):format(status.changed or 0) },
				{ "StatusLineDiffDelete", (" -%d "):format(status.removed or 0) },
			}
	end)
	:add(function(is_active)
		if not is_active then
			return
		end

		local bufnr = api.nvim_get_current_buf()
		local lsp_clients = vim.tbl_filter(function(client)
			return client.attached_buffers[bufnr]
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

		local has_signs = true
		local function get_sign(name)
			local signs = vim.fn.sign_getdefined(name)

			if not signs[1] then
				has_signs = false
				return
			end

			local text = signs[1].text

			return text:sub(1, -2)
		end

		local signs = {
			error = get_sign("DiagnosticSignError"),
			warn = get_sign("DiagnosticSignWarn"),
			info = get_sign("DiagnosticSignInfo"),
			hint = get_sign("DiagnosticSignHint"),
		}

		return vim.list_extend({
			{ "StatusLineActive", "%=" },
			{ "StatusLineLSPServer", client_names },
		}, has_signs and {
			{
				"StatusLineLSPError",
				(" %s: %d "):format(signs.error, diagnostic_count[severity.ERROR]),
			},
			has_signs and {
				"StatusLineLSPWarn",
				(" %s: %d "):format(signs.warn, diagnostic_count[severity.WARN]),
			},
			has_signs and {
				"StatusLineLSPInfo",
				(" %s: %d "):format(signs.info, diagnostic_count[severity.INFO]),
			},
			has_signs and {
				"StatusLineLSPHint",
				(" %s: %d "):format(signs.hint, diagnostic_count[severity.HINT]),
			},
		} or {})
	end)
	:add(function(is_active)
		return { { is_active and "StatusLineActive" or "StatusLineInactive", "" } }
	end)

local tabline_builder = Builder
	:new()
	:add(function()
		local tabs = api.nvim_list_tabpages()
		local current_tab = api.nvim_get_current_tabpage()

		for i, tabpageid in ipairs(tabs) do
			if tabpageid == current_tab then
				return { { "TabLinePages", ("(%d/%d) "):format(i, #tabs) } }
			end
		end
	end)
	:add(function()
		return { { "TabLineSel", ("%s "):format(cwd) } }
	end)
	:add(function()
		local lsp_clients = vim.lsp.get_active_clients()

		if #lsp_clients == 0 then
			return
		end

		local severity = vim.diagnostic.severity
		local diagnostic_count = {
			[severity.ERROR] = 0,
			[severity.WARN] = 0,
			[severity.INFO] = 0,
			[severity.HINT] = 0,
		}
		local buf_diagnostics = vim.diagnostic.get()
		for _, diagnostic in ipairs(buf_diagnostics) do
			diagnostic_count[diagnostic.severity] = diagnostic_count[diagnostic.severity] + 1
		end

		local has_signs = true
		local function get_sign(name)
			local signs = vim.fn.sign_getdefined(name)

			if not signs[1] then
				has_signs = false
				return
			end

			local text = signs[1].text

			return text:sub(1, -2)
		end

		local signs = {
			error = get_sign("DiagnosticSignError"),
			warn = get_sign("DiagnosticSignWarn"),
			info = get_sign("DiagnosticSignInfo"),
			hint = get_sign("DiagnosticSignHint"),
		}

		return has_signs
			and {
				{ "TabLine", "%=" },
				{
					"TabLineLSPError",
					(" %s: %d "):format(signs.error, diagnostic_count[severity.ERROR]),
				},
				{
					"TabLineLSPWarn",
					(" %s: %d "):format(signs.warn, diagnostic_count[severity.WARN]),
				},
				{
					"TabLineLSPInfo",
					(" %s: %d "):format(signs.info, diagnostic_count[severity.INFO]),
				},
				{
					"TabLineLSPHint",
					(" %s: %d "):format(signs.hint, diagnostic_count[severity.HINT]),
				},
			}
	end)
	:add(function()
		return { { "TabLine", "" } }
	end)

function M.build_statusline()
	local current_win = api.nvim_get_current_win()
	local focused_win = util.get_focused_win()
	local statusline_type = current_win == focused_win and "active" or "inactive"

	return sline_bd:build(statusline_type)
end

function M.build_tabline()
	return tabline_builder:build()
end

return M
