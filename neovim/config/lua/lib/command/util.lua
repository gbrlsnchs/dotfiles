local M = {}

function M.create_opts_factory(defaults)
	defaults = defaults or {}

	return function(opts)
		return vim.tbl_deep_extend("force", defaults, opts or {})
	end
end

return M
