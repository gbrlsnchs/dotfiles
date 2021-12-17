local logger = require("lib.logger")

local mods = {
	"notification",
	"env",
	"colorscheme",
	"statusline",
}

for _, mod in ipairs(mods) do
	local mod_path = "init." .. mod
	local ok, err = pcall(require, mod_path)
	if not ok then
		logger.errorf("Unable to require %q: %s", mod_path, err)
	else
		logger.debugf("Initialized %q", mod_path)
	end
end

logger.info("Initialized all modules")

require("opt")
require("deps")
