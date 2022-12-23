vim.filetype.add({
	extension = {
		gcfg = "dosini",
	},
	pattern = {
		[".nvimrc"] = "yaml",
		[".*/srcpkgs/.*/template"] = "sh", -- Void Linux templates.
		[".*/zsh/.*/functions/.*"] = "zsh",
		["/var/tmp/grub%..*"] = "grub", -- For GRUB config edit via 'sudoedit'.
		[".*/sway/config/.*"] = "swayconfig",
		[".*/sway/template/.*"] = "swayconfig",
	},
})
