local cached_opts

local M = {}

function M.load_opts()
	return cached_opts
end

function M.save_opts(opts)
	cached_opts = opts
end

return M
