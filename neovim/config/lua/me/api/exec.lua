local loop = vim.loop

local M = {}

local function handle(tbl)
	return function(err, data)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		local lines = vim.split(data or "", "\n")
		for _, l in ipairs(lines) do
			if l ~= "" then
				table.insert(tbl, l)
			end
		end
	end
end

--- Executes a non-interactive program and pass response to a callback.
--- @param cmd string: Command to be executed.
--- @param args table: List of arguments passed to the command.
--- @param callback function: Handler for the command, receives response and exit code.
function M.cmd(cmd, args, callback)
	local stdout = loop.new_pipe(false)
	local stderr = loop.new_pipe(false)
	local results = {}
	local proc

	proc = loop.spawn(
		cmd,
		{
			args = args,
			stdio = { nil, stdout, stderr },
		},
		vim.schedule_wrap(function(exit_code)
			stdout:read_stop()
			stderr:read_stop()

			stdout:close()
			stderr:close()

			proc:close()

			callback(results, exit_code)
		end)
	)
	loop.read_start(stdout, handle(results))
	loop.read_start(stderr, handle(results))
end

return M
