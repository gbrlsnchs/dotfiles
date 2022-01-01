local logger = require("lib.logger")

local function load_mods(dir, mods, allowlist)
	allowlist = allowlist or {}

	local total = 0
	for _, mod in ipairs(mods) do
		local mod_path = ("%s.%s"):format(dir, mod)
		local ok, err = pcall(require, mod_path)
		if ok then
			logger.debugf("Initialized %q", mod_path)
			total = total + 1
		else
			logger.errorf("Unable to require %q: %s", mod_path, err)
		end
	end

	logger.infof("Total modules loaded from %q: %d/%d", dir, total, #mods)
end

load_mods("opts", {
	"notification",
	"env",
	"session",
	"ui",
	"editor",
	"colorscheme",
	"statusline",
	"command",
	"buffers",
	"files",
	"terminal",
	"completion",
	"search",
	"tabline",
	"latex",
})
load_mods("deps", { "lsp", "tree_sitter", "git", "helpers", "explorer", "editor" })
