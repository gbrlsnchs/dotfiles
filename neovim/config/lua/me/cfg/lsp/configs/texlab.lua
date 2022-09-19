local M = {
	settings = {
		texlab = {
			forwardSearch = {
				executable = "zathura",
				args = {
					"--synctex-forward",
					"%l:1:%f",
					"%p",
				},
			},
		},
	},
}

return M
