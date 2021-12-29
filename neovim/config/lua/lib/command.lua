local fuzzy = require("lib.fuzzy")
local logger = require("lib.logger")

local global_cmdlist = {}
local buffer_cmdlist = {}

local api = vim.api
local action_types = fuzzy.action_types

local function make_excmd(name, bufnr, opts)
	local nargs = opts.nargs or "0"
	local complete = opts.complete

	local excmd = "command -nargs=" .. nargs

	if complete then
		excmd = excmd .. " -complete=" .. complete
	end

	if bufnr then
		excmd = excmd .. " -buffer"
	end

	return ("%s %s %s"):format(excmd, name, opts.exec)
end

local function make_mapping_fn(name, bufnr, opts)
	local binds = {}

	local function push_bind(mappings, arg)
		if not mappings then
			return
		end

		local cmd = name
		if arg then
			cmd = name .. " " .. arg
		end

		table.insert(binds, {
			mode = mappings.mode or "n",
			keys = mappings.bind,
			cmd = "<Cmd>" .. cmd .. "<CR>",
		})
	end

	local mappings = opts.mappings
	local mappings_opts = { noremap = true, silent = true }

	push_bind(mappings)

	local actions = opts.actions or {}
	for _, action in pairs(actions) do
		push_bind(action.mappings, action.arg)
	end

	if #binds == 0 then
		return nil
	end

	if bufnr then
		return function()
			for _, bind in ipairs(binds) do
				api.nvim_buf_set_keymap(bufnr, bind.mode, bind.keys, bind.cmd, mappings_opts)
			end
		end
	end

	return function()
		for _, bind in ipairs(binds) do
			api.nvim_set_keymap(bind.mode, bind.keys, bind.cmd, mappings_opts)
		end
	end
end

local M = {}

function M.add(description, opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, {
		mappings = nil,
		group = nil,
		bufnr = nil,
		actions = nil,
	})

	local cmdlist = global_cmdlist

	local bufnr = opts.bufnr
	if bufnr then
		if not buffer_cmdlist[bufnr] then
			logger.debugf("Initializing command cache for buffer #%d", bufnr)

			buffer_cmdlist[bufnr] = {}
		end

		cmdlist = buffer_cmdlist[bufnr]
	end

	local name = opts.name

	-- If the command is already set, we don't need to do anything else here.
	if cmdlist[name] then
		return
	end

	local excmd = make_excmd(name, bufnr, opts)

	-- First time registering the command, so let's set it up.
	if bufnr then
		api.nvim_buf_call(bufnr, function()
			vim.cmd(excmd)
			vim.cmd(
				"autocmd BufDelete <buffer> call v:lua.require'lib.command'.clear(expand('<abuf>'))"
			)
		end)
	else
		vim.cmd(excmd)
	end

	local map_keys = make_mapping_fn(name, bufnr, opts)
	if map_keys then
		map_keys()
	end

	logger.debugf("Registering %q with the following description: %q", name, description)

	cmdlist[name] = {
		description = description,
		group = opts.group,
		mappings = opts.mappings,
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
		if not a.group then
			return true
		end

		return b.group and a.group < b.group
	end)

	return cmdlist
end

--Segment fault:
--local func = function()
--	vim.cmd("echo 'hello'")
--end

--if local_cmd then
--	func = function()
--		api.nvim_buf_call(bufnr, func)
--	end
--end

--func()

function M.clear(bufnr)
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
				cmd.mappings and cmd.mappings.bind or "---",
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
