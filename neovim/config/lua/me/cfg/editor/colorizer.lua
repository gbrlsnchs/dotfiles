local config = require("me.api.config")

if not config.get("editor", "colorizer") then
	return
end

local util = require("me.api.util")

util.packadd("nvim-colorizer.lua")

local colorizer = require("colorizer")
colorizer.setup()
