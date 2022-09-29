local config = require("me.api.config")
local oldfiles = require("me.api.oldfiles")

local api = vim.api
local augroup = api.nvim_create_augroup("cmd_au", {})

api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	pattern = "*",
	command = "silent! lcd .",
})

api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	pattern = "*",
	command = "startinsert",
})

api.nvim_create_autocmd("BufWritePost", {
	pattern = ".nvimrc",
	callback = function()
		vim.notify("Reloading Neovim configuration (it has changed)")
		config.read()
	end,
	group = augroup,
})

api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	once = true,
	callback = function()
		local project_name = config.get("session", "project_name")
		if not project_name then
			vim.notify(
				"Skipping setup of oldfiles due to missing project name",
				vim.log.levels.WARN
			)
			return true
		end

		local ok = oldfiles.init(project_name)

		if ok then
			api.nvim_create_autocmd("BufWinEnter", {
				group = augroup,
				pattern = "?*",
				callback = function()
					oldfiles.upsert_hits(project_name)
				end,
			})
		end

		return true
	end,
})

local editor_opts = config.get("editor")
if not editor_opts.autocompletion and not editor_opts.float_preview then
	api.nvim_create_autocmd("WinEnter", {
		callback = function()
			local is_preview = vim.opt_local.previewwindow:get()
			local has_ft = vim.opt_local.filetype:get() ~= ""

			if is_preview and not has_ft then
				vim.opt_local.filetype = "markdown"
			end
		end,
		group = augroup,
	})
end
