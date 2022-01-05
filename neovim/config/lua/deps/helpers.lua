local features = require("features")
local util = require("lib.util")

if util.feature_is_on(features.colorize_hex) then
	util.packadd("nvim-colorizer.lua")
end

local winpick = require("winpick")

winpick.setup({ border = "single" })
