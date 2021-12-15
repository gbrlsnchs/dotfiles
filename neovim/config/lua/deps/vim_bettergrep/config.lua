return function()
	vim.g.bettergrep_no_mappings = true
	vim.g.bettergrepprg = "rg --vimgrep --no-heading --smart-case"
end
