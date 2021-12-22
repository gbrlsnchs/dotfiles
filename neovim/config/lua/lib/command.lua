local logger = require("lib.logger")

local global_cmd_info = {}
local global_cmd_desc = {}

local local_cmd_info = {}
local local_cmd_desc = {}

local api = vim.api

local M = {}

M.tags = {
	vertical = "#vertical",
	horizontal = "#horizontal",
	tab = "#newtab",
}

local function init_buf(bufnr)
	if not local_cmd_info[bufnr] then
		local_cmd_info[bufnr] = {}
	end
	if not local_cmd_desc[bufnr] then
		local_cmd_desc[bufnr] = {}
	end
end

function M.add(cmd, desc, opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, {
		keymap = nil,
		group = nil,
		bufnr = nil,
	})

	local cmd_info = global_cmd_info
	local cmd_desc = global_cmd_desc

	local bufnr = opts.bufnr
	if bufnr then
		logger.debugf("Initializing command cache for buffer #%d", bufnr)

		init_buf(bufnr)
		cmd_info = local_cmd_info[bufnr]
		cmd_desc = local_cmd_desc[bufnr]
	end

	--local keys
	--if opts.keymap then
	--	keys = opts.keymap.keys
	--	if keys then
	--		desc = ("%s (%s)"):format(desc, keys)
	--	end
	--end

	if opts.group then
		desc = ("[%s] %s"):format(opts.group, desc)
	end

	if opts.tag then
		desc = desc .. opts.tag
	end

	if cmd_info[desc] then
		return
	end

	logger.debugf("Registering command with the following description: %q", desc)

	table.insert(cmd_desc, desc)
	cmd_info[desc] = cmd

	local keys = opts.keymap.keys
	if keys then
		local mode = opts.keymap.mode or "n"
		cmd = "<Cmd>" .. cmd .. "<CR>"

		if bufnr then
			api.nvim_buf_set_keymap(bufnr, mode, keys, cmd, { noremap = true })
			api.nvim_buf_call(bufnr, function()
				vim.cmd(
					"autocmd BufDelete <buffer> call v:lua.require'lib.command'.clear(expand('<abuf>'))"
				)
			end)
		else
			api.nvim_set_keymap(mode, keys, cmd, { noremap = true })
		end
	end
end

function M.list(bufnr)
	logger.debugf("Listing commands for buffer #%d", bufnr)

	local buf_descriptions = local_cmd_desc[bufnr] or {}
	local all_descriptions = vim.list_extend(vim.list_slice(global_cmd_desc), buf_descriptions)

	logger.tracef("buf_descriptions: %s", vim.inspect(buf_descriptions))
	logger.tracef("all_descriptions: %s", vim.inspect(all_descriptions))

	return vim.fn.sort(vim.fn.filter(all_descriptions, function(_, desc)
		for _, tag in pairs(M.tags) do
			if desc:sub(-#tag) == tag then
				return false
			end
		end

		return true
	end))
end

function M.run(bufnr, description, tag)
	tag = tag or ""

	local cmdlist = local_cmd_info[bufnr] or global_cmd_info
	local command = cmdlist[description .. tag]
		or cmdlist[description]
		or global_cmd_info[description .. tag]
		or global_cmd_info[description]

	command = (":%s\n"):format(command)

	vim.cmd("stopinsert")
	api.nvim_feedkeys(command, "n", false)

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
end

function M.clear(bufnr)
	logger.debugf("Clearing commands for buffer #%d", bufnr)

	local_cmd_desc[bufnr] = nil
	local_cmd_info[bufnr] = nil
end

return M
