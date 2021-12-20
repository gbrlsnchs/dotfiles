local commands = {}
local descriptions = {}

local api = vim.api

local M = {}

function M.add(cmd, desc, opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, {
		keymap = nil,
		group = nil,
		bufnr = nil,
	})

	if opts.keymap then
		local mode = opts.keymap.mode
		local keys = opts.keymap.keys
		local bufnr = opts.bufnr

		desc = ("%s (%s)"):format(desc, keys)

		local set_keymap = bufnr == nil and api.nvim_set_keymap
			or function(buf_mode, buf_keys, buf_cmd, buf_opts)
				api.nvim_buf_set_keymap(bufnr, buf_mode, buf_keys, buf_cmd, buf_opts)
			end

		set_keymap(mode, keys, "<Cmd>" .. cmd .. "<CR>", { noremap = true })
	end

	if opts.group then
		desc = ("[%s] %s"):format(opts.group, desc)
	end

	table.insert(descriptions, desc)
	commands[desc] = cmd
end

function M.list()
	return vim.fn.sort(descriptions)
end

function M.find(desc)
	return commands[desc]
end

return M
