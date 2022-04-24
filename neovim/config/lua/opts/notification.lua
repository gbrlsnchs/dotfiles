local Job = require("plenary.job")

local logger = require("lib.logger")

local function notify(msg, level_title, urgency_level)
	Job
		:new({
			command = "notify-send",
			args = { "--expire-time", "5000", "--app-name", "Neovim", "--urgency", urgency_level, level_title, msg },
			cwd = vim.fn.getcwd(),
			interactive = false,
		})
		:start()
end

-- Default value includes "error", "warn" and "info".
-- Error logs cannot be disabled.
local max_log_level = tonumber(vim.env.NVIM_LOG_LEVEL) or logger.levels.INFO

vim.notify = function(msg, log_level, _)
	log_level = log_level or max_log_level
	if log_level > max_log_level then
		return
	end

	local urgency
	local level_title

	if log_level == logger.levels.ERROR then
		urgency = "critical"
		level_title = "ERROR"
	elseif log_level == logger.levels.WARN then
		urgency = "normal"
		level_title = "WARN"
	else
		urgency = "low"
		if log_level == logger.levels.INFO then
			level_title = "INFO"
		elseif log_level == logger.levels.DEBUG then
			level_title = "DEBUG"
		else
			level_title = "TRACE"
		end
	end

	notify(msg, level_title, urgency)
end
