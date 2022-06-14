local util = require("me.api.util")
local win = require("me.api.win")
local line = require("me.api.line")
local Builder = require("me.api.line.builder")
local log = require("me.api.log")

local api = vim.api
local cwd = vim.loop.cwd()
local log_levels = vim.log.levels
local git_cache = {}

--- Resolves highlight group based on whether the window is focused.
--- @param hl string: The highlight group.
--- @param is_focused boolean: Whether the current component is in a focused window.
--- @return string: The resolved name for the highlight group.
local function hl_focus(hl, is_focused)
	hl = hl or ""
	local focus_prefix = (is_focused and "") or "NC"

	return focus_prefix .. hl
end

--- Returns a function that introduces blank gaps.
--- @param size number: Gap size.
--- @param hl string: Highlight group for the gap.
--- @return function: Function that sets gap.
local function spacing(size, hl)
	local gap = string.rep(" ", size)

	return function(is_focused)
		return { hl = hl_focus(hl, is_focused), content = gap }
	end
end

--- Returns a function that resets the bar to a given highlight group.
--- @param hl string: Highlight group for the reset.
--- @return function: Function that resets the bar.
local function reset(hl)
	return function(is_focused)
		return { hl = hl_focus(hl, is_focused), content = nil }
	end
end

local function align_right(is_focused)
	return { hl = hl_focus(nil, is_focused), content = "%=" }
end

local function lsp_info(global)
	return function(is_focused)
		if not is_focused then
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
		client_names = client_names .. " "

		local severity = vim.diagnostic.severity
		local diagnostic_count = {
			[severity.ERROR] = 0,
			[severity.WARN] = 0,
			[severity.INFO] = 0,
			[severity.HINT] = 0,
		}
		local buf_diagnostics = (global and vim.diagnostic.get()) or vim.diagnostic.get(0)
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

		return vim.list_extend((not global and {
			spacing(1, "LSPServer"),
			{ hl = "LSPServer", content = "[LSP] " .. client_names },
		}) or {}, has_signs and {
			spacing(1, "LSPError"),
			{
				hl = "LSPError",
				content = string.format("%s: %d", signs.error, diagnostic_count[severity.ERROR]),
			},
			spacing(1, "LSPError"),
			spacing(1, "LSPWarn"),
			has_signs and {
				hl = "LSPWarn",
				content = string.format("%s: %d", signs.warn, diagnostic_count[severity.WARN]),
			},
			spacing(1, "LSPWarn"),
			spacing(1, "LSPInfo"),
			has_signs and {
				hl = "LSPInfo",
				content = string.format("%s: %d", signs.info, diagnostic_count[severity.INFO]),
			},
			spacing(1, "LSPInfo"),
			spacing(1, "LSPHint"),
			has_signs and {
				hl = "LSPHint",
				content = string.format("%s: %d", signs.hint, diagnostic_count[severity.HINT]),
			},
			spacing(1, "LSPHint"),
		} or {})
	end
end

--- Sets up winbar.
--- @param opts table: Options for this bar.
--- @return table: Builder that builds the bar.
local function setup_winbar(opts)
	local winbar = Builder
		:new("WinBar")
		:add(spacing(1, "FileInfo"))
		:add("[Buffer]")
		:add(spacing(1, "FileInfo"))
		:add(function(is_focused)
			local bufnr = api.nvim_get_current_buf()
			local is_modified = api.nvim_buf_get_option(bufnr, "modified")
			local hl_mod = (is_modified and "Modified") or ""

			return {
				hl = hl_focus("FileInfo" .. hl_mod, is_focused),
				content = "%f",
			}
		end)
		:add(spacing(1, "FileInfo"))
		:add(align_right)

	if opts.lsp then
		winbar:add(lsp_info(false))
	end

	return winbar
end

local function setup_statusline(opts)
	local statusline = Builder
		:new("StatusLine")

	if opts.git then
		statusline
			:add(function()
				local branch = vim.b.gitsigns_head
				if branch then
					git_cache.branch = branch
				else
					branch = git_cache.branch
				end

				local status = vim.b.gitsigns_status_dict
				if status then
					git_cache.status = status
				else
					status = git_cache.status
				end

				return branch and status and {
					spacing(1),
					{ hl = "Branch", content = "[Git] " .. branch },
					spacing(1),
					spacing(1, "DiffAdd"),
					{ hl = "DiffAdd", content = string.format("+%d", status.added or 0) },
					spacing(1, "DiffAdd"),
					spacing(1, "DiffChange"),
					{ hl = "DiffChange", content = string.format("~%d", status.changed or 0) },
					spacing(1, "DiffChange"),
					spacing(1, "DiffDelete"),
					{ hl = "DiffDelete", content = string.format("-%d", status.removed or 0) },
					spacing(1, "DiffDelete"),
					reset(),
				}
			end)
	end

	if opts.logs then
		statusline
			:add(spacing(2))
			:add(function()
				local unread_logs = log.get_unread()

				local verb = "are"
				local plural = "s"

				if unread_logs.count == 1 then
					verb = "is"
					plural = ""
				end

				local severity_hl
				local severity = unread_logs.severity

				if severity == log_levels.ERROR then
					severity_hl = "Error"
				elseif severity == log_levels.WARN then
					severity_hl = "Warn"
				elseif severity == log_levels.INFO then
					severity_hl = "Info"
				elseif severity == log_levels.DEBUG then
					severity_hl = "Debug"
				elseif severity == log_levels.TRACE then
					severity_hl = "Trace"
				end

				local count = unread_logs.count

				return count > 0 and {
					{ hl = "Notification" .. severity_hl, content = string.format(" There %s %d new log%s ", verb, count, plural) },
				}
			end)
			:add(spacing(1))
			:add(reset())
	end

	statusline
		:add("%=")
		:add(function()
			local tabs = api.nvim_list_tabpages()
			local current_tab = api.nvim_get_current_tabpage()

			for idx, tab in ipairs(tabs) do
				if tab == current_tab then
					return string.format("Tab %d of %d", idx, #tabs)
				end
			end
		end)
		:add(spacing(2))

	if opts.lsp then
		statusline:add(lsp_info(true))
	end

	return statusline
end

local function setup_tabline(opts)
	local tabline = Builder
		:new()
		:add("    " .. cwd .. "    ")


	tabline
		:add(function()
			return { { "TabLine", "%=" } }
		end)
		:add(function()
			local tabs = api.nvim_list_tabpages()
			local current_tab = api.nvim_get_current_tabpage()

			for i, tabpageid in ipairs(tabs) do
				if tabpageid == current_tab then
					return { { "TabLine", string.format("    Tab %d of %d    ", i, #tabs) } }
				end
			end
		end)

	if opts.lsp then
		tabline
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
						{
							"TabLineLSPError",
							("  %s: %d "):format(signs.error, diagnostic_count[severity.ERROR]),
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
	end

	tabline:add(function()
		return { { "TabLine", "" } }
	end)

	return tabline
end

local M = {}

--- Sets up statusline.
function M.setup(opts)
	opts = util.tbl_merge(opts, {
		git = true,
		lsp = true,
		logs = true,
	})

	local group = api.nvim_create_augroup("bars", {})
	api.nvim_create_autocmd({ "VimEnter", "WinEnter", "WinLeave" }, {
		group = group,
		callback = function()
			win.set_focused()
		end,
	})

	line.set("statusline", setup_statusline(opts))
	line.set("winbar", setup_winbar(opts))

	vim.opt.statusline = [[%{%v:lua.require('me.api.line').get('statusline')%}]]
	vim.opt.laststatus = 3

	vim.opt.showtabline = 0

	vim.opt.winbar = [[%{%v:lua.require('me.api.line').get('winbar')%}]]
end

return M
