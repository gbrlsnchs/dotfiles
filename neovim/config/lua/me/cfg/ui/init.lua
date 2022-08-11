local util = require("me.api.util")
local fzf = require("me.cfg.ui.fzf")

local api = vim.api
local augroup = api.nvim_create_augroup("ui", {})

--- Sets up indent guides.
--- @param enabled boolean: Whether the feature should be loaded.
local function setup_indent_guides(enabled)
	if not enabled then
		return
	end

	util.packadd("indent-blankline.nvim")

	local indent_blankline = require("indent_blankline")
	local indent_blankline_cmd = require("indent_blankline.commands")

	api.nvim_create_autocmd("ModeChanged", {
		group = augroup,
		pattern = "*:[vV\x16]*",
		callback = function()
			vim.schedule(function()
				indent_blankline_cmd.disable()
			end)
		end,
	})

	api.nvim_create_autocmd("ModeChanged", {
		group = augroup,
		pattern = "[vV\x16]*:*",
		callback = function()
			vim.schedule(function()
				indent_blankline_cmd.enable()
			end)
		end,
	})

	indent_blankline.setup({
		use_treesitter = true,
		show_trailing_blankline_indent = false,
		filetype_exclude = { "help", "lspinfo" },
		buftype_exclude = { "nofile", "terminal" },
	})
end

local function setup_pqf(enabled)
	if not enabled then
		return
	end

	util.packadd("nvim-pqf")

	local pqf = require("pqf")
	pqf.setup()
end

local M = {}

function M.setup(opts)
	opts = util.tbl_merge(opts, {
		indent_guides = true,
		pretty_quickfix = true,
	})

	vim.ui.select = fzf.select

	setup_indent_guides(opts.indent_guides)
	setup_pqf(opts.pretty_quickfix)
end

return M
