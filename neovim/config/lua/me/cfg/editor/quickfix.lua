local config = require("me.api.config")

if not config.get("editor", "pretty_quickfix") then
	return
end

local util = require("me.api.util")

util.packadd("nvim-pqf")

local pqf = require("pqf")
pqf.setup()
