local Job = require("plenary.job")

local function notify(msg, urgency_level)
	Job
		:new({
			command = "notify-send",
			args = {
				-- "--icon",
				-- "/usr/share/icons/hicolor/128x128/apps/nvim.png",
				"--urgency",
				urgency_level,
				msg,
			},
			cwd = vim.fn.getcwd(),
			interactive = false,
		})
		:start()
end

return function(msg, log_level, _)
	local urgency
	if log_level == vim.log.levels.ERROR then
		urgency = "critical"
	elseif log_level == vim.log.levels.WARN then
		urgency = "normal"
	else
		urgency = "low"
	end

	notify(msg, urgency)
end
