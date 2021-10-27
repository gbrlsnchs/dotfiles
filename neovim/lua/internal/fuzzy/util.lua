local M = {}

local function open_at_line(line)
	vim.api.nvim_win_set_cursor(0, { line, 0 })
end

function M.buffer_wrap(fn)
	return function(bufnr, line)
		fn(function()
			open_at_line(line)
		end, { bufnr = bufnr })
	end
end

return M
