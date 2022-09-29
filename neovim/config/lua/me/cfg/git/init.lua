local config = require("me.api.config")

config.set("git", {
	enabled = true,
})

if not config.get("git", "enabled") then
	error("Git module is disabled")
end
