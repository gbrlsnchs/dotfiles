local util = require("me.api.util")

local api = vim.api

local valid_modes = { "n", "v" }

--- Global list of commands. Filled once, cannot be cleared.
local global_cmdlist = {
	n = {},
	v = {},
}
--- Buffer-only list of commands. Filled once, can be cleared.
local buffer_cmdlist = {
	n = {},
	v = {},
}

--- Registers a command, optionally setting keymaps for it.
--- @param name string: Name of the command.
--- @param desc string: Description of the command.
--- @param callback function: Callback executed by the command.
--- @param opts table: Options for the command.
local function register(name, desc, mode, callback, opts)
	opts = opts or {}

	local cmdlist = global_cmdlist[mode]
	local bufnr = opts.buffer
	local cmd_add = api.nvim_create_user_command
	local keymap_add = api.nvim_set_keymap

	if bufnr then
		cmdlist = buffer_cmdlist[mode]
		if not cmdlist[bufnr] then
			cmdlist[bufnr] = {}
			api.nvim_create_autocmd("BufDelete", {
				once = true,
				buffer = bufnr,
				callback = function(cmd)
					cmdlist[cmd.buf] = nil

					return true
				end,
			})
		end

		cmdlist = cmdlist[bufnr]
		cmd_add = function(...)
			api.nvim_buf_create_user_command(bufnr, ...)
		end
		keymap_add = function(...)
			api.nvim_buf_set_keymap(bufnr, ...)
		end
	end

	-- If the command is already set, we don't need to do anything else here.
	if cmdlist[name] then
		return
	end

	cmd_add(name, callback, {
		range = opts.range,
		nargs = opts.nargs,
		complete = opts.complete,
		desc = desc,
	})

	local keymap = opts.keymap
	if keymap then
		if mode == "n" then
			keymap_add(mode, keymap.keys, "", {
				noremap = true,
				desc = desc,
				callback = callback,
			})
		else
			keymap_add(mode, keymap.keys, ":" .. name .. "<CR>", {
				noremap = true,
				desc = desc,
			})
		end

		local actions = opts.actions or {}
		for _, action_opts in pairs(actions) do
			local action_keymap = action_opts.keymap
			if action_keymap then
				keymap_add(mode, action_keymap.keys, "", {
					noremap = true,
					desc = string.format("%s (%s)", desc, action_opts.desc or action_opts.arg),
					callback = function(cmd)
						local arg = action_opts.arg
						local keymap_bufnr = api.nvim_get_current_buf()

						if type(arg) == "function" then
							arg = action_opts.arg(keymap_bufnr)
						end

						cmd = cmd or { fargs = { arg } }
						callback(cmd)
					end,
				})
			end
		end
	end

	cmdlist[name] = {
		desc = desc,
		group = opts.group,
		keymap = opts.keymap,
		actions = opts.actions,
		name = name,
	}
end

local M = {}

--- Registers a group of commands.
--- @param group string: The group's name.
--- @param commands table: List of commands to be registered to the group.
function M.register(group, commands)
	for cmd_name, config in pairs(commands) do
		local opts = util.tbl_merge(config.opts, { group = group })
		local modes = opts.modes or { "n" }

		opts.range = vim.tbl_contains(modes, "v")

		for _, mode in ipairs(modes) do
			if vim.tbl_contains(valid_modes, mode) then
				register(cmd_name, config.desc, mode, config.callback, opts)
			else
				vim.notify(
					string.format("Tried to register invalid mode %q for command %q", mode, cmd_name),
					vim.log.levels.WARN
				)
			end
		end
	end
end

--- Lists all registered commands. If 'bufnr' is passed, it tries to list all commands registered -
--- for that buffer.
--- @param bufnr number: Optional buffer number.
--- @return table | nil: Table of registered commands.
function M.list(bufnr, mode)
	if not vim.tbl_contains(valid_modes, mode) then
		vim.notify(string.format("Invalid mode for command list: %q", mode), vim.log.levels.WARN)
		return
	end

	local cmdlist = {}
	for _, cmd in pairs(global_cmdlist[mode]) do
		table.insert(cmdlist, cmd)
	end
	for _, cmd in pairs(vim.tbl_get(buffer_cmdlist, mode, bufnr) or {}) do
		table.insert(cmdlist, cmd)
	end

	table.sort(cmdlist, function(a, b)
		if not a.group and not b.group then
			return a.desc < b.desc
		end

		if not a.group then
			return true
		end

		if not b.group then
			return false
		end

		if a.group < b.group then
			return true
		end

		if a.group > b.group then
			return false
		end

		return a.desc < b.desc
	end)

	return cmdlist
end

return M
