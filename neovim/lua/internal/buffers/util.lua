local api = vim.api

local M = {}

function M.create_buf(opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, {
		bufnr = nil,
		listed = true,
	})

	return opts.bufnr or api.nvim_create_buf(opts.listed, false)
end

function M.open_buf(bufnr, fn)
	print("bufnr: " .. bufnr)
	api.nvim_buf_call(bufnr, fn)
	api.nvim_win_set_buf(0, bufnr)
end

function M.parse_bufinfo(bufinfo)
	local vars = bufinfo.variables or {}
	local line = bufinfo.lnum
	if line == 0 then
		line = 1
	end
	return {
		id = bufinfo.bufnr,
		name = vars.term_name or bufinfo.name,
		title = vars.term_title,
		line = line,
		line_count = bufinfo.linecount,
	}
end

function M.is_term(buf)
	local vars = buf.variables or {}

	return vars.terminal_job_pid ~= nil or vars.terminal_job_id ~= nil
end

return M
