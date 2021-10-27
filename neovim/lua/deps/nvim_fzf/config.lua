return function()
	local fzf = require("fzf")

	fzf.default_options = {
		width = 96,
		height = 24,
		window_on_create = function()
			vim.cmd("set winhl=Normal:Normal")
		end,
	}
end
