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
	-- Let's load the buffer first in case it's not loaded yet.
	api.nvim_win_set_buf(0, bufnr)
	-- Then we proceed to execute fn in the buffer.
	api.nvim_buf_call(bufnr, fn)
end

function M.parse_bufinfo(bufinfo)
	local vars = bufinfo.variables or {}
	local line = bufinfo.lnum
	if line == 0 then
		line = 1
	end
	return {
		id = bufinfo.bufnr,
		name = vars.term_title or bufinfo.name,
		line = line,
		line_count = bufinfo.linecount,
	}
end

function M.is_term(buf)
	local vars = buf.variables or {}

	return vars.terminal_job_pid ~= nil or vars.terminal_job_id ~= nil
end

return M
