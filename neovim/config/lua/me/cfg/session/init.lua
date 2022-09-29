local config = require("me.api.config")

config.set("session", {
	project_name = vim.loop.cwd(),
})
