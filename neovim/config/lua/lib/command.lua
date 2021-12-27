local logger = require("lib.logger")

local global_cmdlist = {}
local buffer_cmdlist = {}

local api = vim.api

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
	local mappings = opts.mappings

	if not mappings then
		return nil
	end

	local mode = mappings.mode or "n"
	local exec = "<Cmd>" .. name .. "<CR>"
	local mappings_opts = { noremap = true, silent = true }

	if bufnr then
		return function()
			api.nvim_buf_set_keymap(bufnr, mode, mappings.bind, exec, mappings_opts)
		end
	end

	return function()
		api.nvim_set_keymap(mode, mappings.bind, exec, mappings_opts)
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

		local name = cmd.name

		vim.cmd("stopinsert")
		api.nvim_feedkeys(":" .. name .. "\n", "n", false)
		vim.fn.histadd("cmd", name)
	end)
end

return M
