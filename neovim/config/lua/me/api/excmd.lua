local util = require("me.api.util")

local api = vim.api

--- Global list of commands. Filled once, cannot be cleared.
local global_cmdlist = {}
--- Buffer-only list of commands. Filled once, can be cleared.
local buffer_cmdlist = {}

--- Registers a command, optionally setting keymaps for it.
--- @param name string: Name of the command.
--- @param desc string: Description of the command.
--- @param callback function: Callback executed by the command.
--- @param opts table: Options for the command.
local function register(name, desc, callback, opts)
	opts = opts or {}

	local cmdlist = global_cmdlist
	local bufnr = opts.buffer
	local cmd_add = api.nvim_create_user_command
	local keymap_add = api.nvim_set_keymap

	if bufnr then
		if not buffer_cmdlist[bufnr] then
			buffer_cmdlist[bufnr] = {}
			api.nvim_create_autocmd("BufDelete", {
				once = true,
				buffer = bufnr,
				callback = function(cmd)
					buffer_cmdlist[cmd.buf] = nil

					return true
				end,
			})
		end

		cmdlist = buffer_cmdlist[bufnr]
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
		nargs = opts.nargs,
		complete = opts.complete,
		desc = desc,
	})

	local keymap = opts.keymap
	if keymap then
		local mode = keymap.mode or "n"
		keymap_add(mode, keymap.keys, "", {
			noremap = true,
			desc = desc,
			callback = callback,
		})

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
		register(
		cmd_name,
			config.desc,
			config.callback,
			util.tbl_merge(config.opts, { group = group })
		)
	end
end

--- Lists all registered commands. If 'bufnr' is passed, it tries to list all commands registered -
--- for that buffer.
--- @param bufnr number: Optional buffer number.
--- @return table: Table of registered commands.
function M.list(bufnr)
	local cmdlist = {}
	for _, cmd in pairs(global_cmdlist) do
		table.insert(cmdlist, cmd)
	end
	for _, cmd in pairs(buffer_cmdlist[bufnr] or {}) do
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
