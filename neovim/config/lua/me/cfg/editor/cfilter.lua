local config = require("me.api.config")
local util = require("me.api.util")

if config.get("editor", "cfilter") then
	util.packadd("cfilter")
end
