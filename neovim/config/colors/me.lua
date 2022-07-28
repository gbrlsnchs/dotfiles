package.loaded["me.cfg.colorscheme"] = nil

local colorscheme = require("me.cfg.colorscheme")
local cache = require("me.cfg.colorscheme.cache")

local opts = cache.load_opts()

colorscheme.setup(opts)
