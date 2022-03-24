-- NOTE: Remove these after support for filetype.lua is official.
vim.g.did_load_filetypes = 0
vim.g.do_filetype_lua = 1

vim.filetype.add({
	extension = {
		gcfg = "dosini",
		just = "just",
	},
	literals = {
		Justfile = "just",
		justfile = "just",
		[".Justfile"] = "just",
		[".justfile"] = "just",
	},
	pattern = {
		-- Void Linux templates.
		[".*/srcpkgs/.*/template"] = "sh",
	},
})
