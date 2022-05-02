package.loaded["me.colorscheme"] = nil

local colorscheme = require("me.colorscheme")
local cache = require("me.colorscheme.cache")

local opts = cache.load_opts()

colorscheme.setup(opts)
