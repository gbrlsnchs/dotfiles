local M = {}

function M.readonly(tbl)
	local proxy = {}
	local meta = {
		__index = tbl,
		__newindex = function(_, _, _)
			vim.notify("Attempt to set read-only table", vim.lsp.log_levels.ERROR)
		end,
	}

	return setmetatable(proxy, meta)
end

return M
