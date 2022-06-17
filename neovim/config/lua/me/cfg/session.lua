local log = require("me.api.log")

local M = {}

function M.setup()
	log.init()
	vim.notify("Session started")
	log.reset_unread()
end

return M
