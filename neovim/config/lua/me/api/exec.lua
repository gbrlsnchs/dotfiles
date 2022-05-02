local Job = require("plenary.job")

local M = {}

--- Executes a non-interactive program and pass response to a callback.
--- @param cmd string: Command to be executed.
--- @param args table: List of arguments passed to the command.
--- @param callback function: Handler for the command, receives response and exit code.
function M.cmd(cmd, args, callback)
	local job = Job:new({
		command = cmd,
		args = args,
		interactive = false,
		on_exit = vim.schedule_wrap(function(job, exit_code)
			local result = job:result()

			callback(result, exit_code)
		end),
	})

	job:start()
end

return M
