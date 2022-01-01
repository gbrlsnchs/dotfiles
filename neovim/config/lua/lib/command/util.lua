local M = {}

function M.bind_fargs(callback)
	return function(cmd)
		cmd = cmd or {}
		callback(cmd.args)
	end
end

return M
