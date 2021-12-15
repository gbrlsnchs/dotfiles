local winpick = require("winpick")

local util = require("internal.buffers.util")

local api = vim.api

local M = {}

function M.open(fn, opts)
	if not winpick.pick_window() then
		return
	end

	util.open_buf(util.create_buf(opts), fn)
end

function M.open_horizontal(fn, opts)
	if not winpick.pick_window() then
		return
	end

	local bufnr = util.create_buf(opts)

	vim.cmd(("sbuffer %d"):format(bufnr))
	util.open_buf(bufnr, fn)
end

function M.open_vertical(fn, opts)
	if not winpick.pick_window() then
		return
	end

	local bufnr = util.create_buf(opts)

	vim.cmd(("vertical sbuffer %d"):format(bufnr))
	util.open_buf(bufnr, fn)
end

function M.open_tab(fn, opts)
	local bufnr = util.create_buf(opts)

	vim.cmd(("tab sbuffer %d"):format(bufnr))
	util.open_buf(bufnr, fn)
end

function M.list()
	local cur_buf_id = api.nvim_get_current_buf()
	local buf_info = vim.fn.getbufinfo({ buflisted = true, bufloaded = false })
	local result = {
		text_buffers = {},
		term_buffers = {},
	}

	for _, info in ipairs(buf_info) do
		local is_cur_buf = info.bufnr == cur_buf_id
		if is_cur_buf then
			result.current_buf = util.parse_bufinfo(info)
			goto continue
		end

		local buf_list = result.text_buffers
		if util.is_term(info) then
			buf_list = result.term_buffers
		end

		table.insert(buf_list, util.parse_bufinfo(info))

		::continue::
	end

	return result
end

return M
