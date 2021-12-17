local Job = require("plenary.job")

local logger = require("lib.logger")

local function notify(msg, urgency_level)
	Job
		:new({
			command = "notify-send",
			args = { "--urgency", urgency_level, msg },
			cwd = vim.fn.getcwd(),
			interactive = false,
		})
		:start()
end

vim.notify = function(msg, log_level, _)
	local urgency
	local suppress = false

	if log_level == logger.levels.ERROR then
		urgency = "critical"
	elseif log_level == logger.levels.WARN then
		urgency = "normal"
	else
		local trace_on = vim.env.NVIM_TRACE_LOG == "1"
		local debug_on = trace_on or vim.env.NVIM_DEBUG_LOG == "1"

		if log_level == logger.levels.TRACE then
			suppress = not trace_on
		elseif log_level == logger.levels.DEBUG then
			suppress = not debug_on
		end

		urgency = "low"
	end

	if suppress then
		return
	end

	notify(msg, urgency)
end
