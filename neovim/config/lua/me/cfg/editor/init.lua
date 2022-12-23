local winpick = require("winpick")

local config = require("me.api.config")

local api = vim.api

config.set("editor", {
	cfilter = true,
	autocompletion = true,
	preview = false,
	folding = true,
	colorizer = true,
	indent_guides = true,
	pretty_quickfix = true,
	treesitter = {
		enabled = true,
		rainbow = false,
		auto_tagging = true,
		spelling = true,
		commentstring = true,
		context = true,
	},
	options = {
		makeprg = "make",
	},
})

winpick.setup({
	filter = function(winid, bufnr, _, allow_special)
		if not allow_special and api.nvim_win_get_option(winid, "previewwindow") then
			return false
		end

		if not allow_special and api.nvim_buf_get_option(bufnr, "buftype") == "quickfix" then
			return false
		end

		local win_var_denylist = {
			"treesitter_context",
			"treesitter_context_line_number",
		}

		for _, var in ipairs(win_var_denylist) do
			if pcall(api.nvim_win_get_var, winid, var) then
				return false
			end
		end

		return true
	end,
	format_label = false,
})
