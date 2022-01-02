local fuzzy = require("lib.fuzzy")
local logger = require("lib.logger")

local global_cmdlist = {}
local buffer_cmdlist = {}

local api = vim.api
local action_types = fuzzy.action_types

local M = {}

function M.add(name, description, handler, opts)
	opts = opts or {}

	local cmdlist = global_cmdlist
	local bufnr = opts.bufnr
	local cmd_add = api.nvim_add_user_command
	local keymap_add = api.nvim_set_keymap

	if bufnr then
		if not buffer_cmdlist[bufnr] then
			logger.debugf("Initializing command cache for buffer #%d", bufnr)

			buffer_cmdlist[bufnr] = {}
			vim.cmd('autocmd BufDelete <buffer> ++once lua require("lib.command").clear()')
		end

		cmdlist = buffer_cmdlist[bufnr]
		cmd_add = function(...)
			api.nvim_buf_add_user_command(bufnr, ...)
		end
		keymap_add = function(...)
			api.nvim_buf_set_keymap(bufnr, ...)
		end
	end

	-- If the command is already set, we don't need to do anything else here.
	if cmdlist[name] then
		return
	end

	cmd_add(name, handler, {
		nargs = opts.nargs,
		complete = opts.complete,
		desc = description,
	})

	local keymap = opts.keymap
	if keymap then
		local mode = keymap.mode or "n"
		keymap_add(mode, keymap.keys, "", {
			noremap = true,
			desc = description,
			callback = handler,
		})

		local actions = opts.actions or {}
		for _, action_opts in pairs(actions) do
			local action_keymap = action_opts.keymap
			if action_keymap then
				local arg = action_opts.arg
				keymap_add(mode, action_keymap.keys, "", {
					noremap = true,
					desc = string.format("%s (%s)", description, arg),
					callback = function(cmd)
						cmd = cmd or { args = arg }
						handler(cmd)
					end,
				})
			end
		end
	end

	logger.debugf("Registering command %q", name)

	cmdlist[name] = {
		description = description,
		group = opts.group,
		keymap = opts.keymap,
		actions = opts.actions,
		name = name,
	}
end

local function list(bufnr)
	logger.debugf("Listing commands for buffer #%d", bufnr)

	local cmdlist = {}
	for _, cmd in pairs(global_cmdlist) do
		table.insert(cmdlist, cmd)
	end
	for _, cmd in pairs(buffer_cmdlist[bufnr] or {}) do
		table.insert(cmdlist, cmd)
	end

	table.sort(cmdlist, function(a, b)
		if not a.group and not b.group then
			return a.description < b.description
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

		return a.description < b.description
	end)

	return cmdlist
end

function M.clear()
	local bufnr = tonumber(vim.fn.expand("<abuf>"))

	logger.debugf("Clearing commands for buffer #%d", bufnr)

	buffer_cmdlist[bufnr] = nil
end

-- TODO: Accept group filter as parameter.
function M.open_palette()
	local bufnr = vim.api.nvim_get_current_buf()
	local cmdlist = list(bufnr)

	local opts = {
		prompt = "Command palette:",
		actions = { action_types.C_X, action_types.C_V, action_types.C_T },
		index_items = true,
		header = "#\tGroup\tDescription\tKeymap\tCommand",
		format_item = function(cmd)
			local parts = {
				cmd.group or "---",
				cmd.description,
				cmd.keymap and cmd.keymap.keys or "---",
				cmd.name,
			}

			return table.concat(parts, "\t")
		end,
	}

	vim.ui.select(cmdlist, opts, function(cmd)
		if not cmd then
			return cmd
		end

		local excmd = cmd.name
		local chosen_action = fuzzy.get_action()
		local actions = cmd.actions or {}

		local action = actions[chosen_action] or {}
		if action.arg then
			excmd = excmd .. " " .. action.arg
		end

		vim.cmd("stopinsert")
		api.nvim_feedkeys(":" .. excmd .. "\n", "n", false)
		vim.fn.histadd("cmd", excmd)

		logger.debugf("Executed the following command from the palette: %q", excmd)
	end)
end

return M
