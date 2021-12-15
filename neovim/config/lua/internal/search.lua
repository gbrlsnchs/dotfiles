local SearchCommand = require("internal.search.command")

local function rg_smart_case()
	SearchCommand
		:new("ripgrep", "rg", { "--vimgrep", "--no-heading", "--smart-case" })
		:prompt_for_query()
		:run()
end

local function rg_word(opts)
	opts = opts or {}
	local cword

	if opts.WORD then
		cword = "<cWORD>"
	else
		cword = "<cword>"
	end

	cword = vim.fn.expand(cword)

	SearchCommand
		:new("ripgrep cword", "rg", { "--vimgrep", "--no-heading", "--smart-case" })
		:prompt_for_query(cword)
		:run()
end

local function git_grep()
	SearchCommand:new("git grep", "git", { "grep", "--column", "-n" }):prompt_for_query():run()
end

local function fd_file(filename)
	SearchCommand:new("fd <file>", "fd", {}):prompt_for_query(filename):run()
end

return {
	git_grep = git_grep,
	rg_smart_case = rg_smart_case,
	rg_word = rg_word,
	fd_file = fd_file,
}
