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

-- Default value includes "error", "warn" and "info".
-- Error logs cannot be disabled.
local max_log_level = tonumber(vim.env.NVIM_LOG_LEVEL) or 2

vim.notify = function(msg, log_level, _)
	if log_level >= max_log_level then
		return
	end

	local urgency

	if log_level == logger.levels.ERROR then
		urgency = "critical"
	elseif log_level == logger.levels.WARN then
		urgency = "normal"
	else
		urgency = "low"
	end

	notify(msg, urgency)
end
