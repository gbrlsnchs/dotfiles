local command = require("lib.command")
local command_util = require("lib.command.util")

vim.g.mapleader = " "

local function nmap(key, cmd)
	vim.api.nvim_set_keymap("n", key, cmd, { noremap = true })
end

local with_default_fuzzy_opts = command_util.create_factory({ group = "Fuzzy" })

-- Buffers.
nmap("]b", "<Cmd>bnext<CR>")
nmap("[b", "<Cmd>bNext<CR>")
command.add("bdelete", "Delete buffer", with_default_fuzzy_opts("<Leader>bD"))
command.add("Bdelete", "Delete buffer and close window", with_default_fuzzy_opts("<Leader>bd"))
command.add("bwipeout", "Wipe out buffer", with_default_fuzzy_opts("<Leader>bW"))
command.add("Bwipeout", "Wipe out buffer and close window", with_default_fuzzy_opts("<Leader>bw"))

-- Loclist/quickfix.
nmap("]l", "<Cmd>lnext<CR>")
nmap("[l", "<Cmd>lprevious<CR>")
nmap("]q", "<Cmd>cnext<CR>")
nmap("[q", "<Cmd>cprevious<CR>")

-- Fuzzy finding.
command.add(
	'lua require("internal.fuzzy").find({ use_file_cwd = true })',
	"Find files in the current directory",
	with_default_fuzzy_opts("<Leader>f.")
)
command.add(
	'lua require("internal.fuzzy").buffers()',
	"Find buffers",
	with_default_fuzzy_opts("<Leader>fb")
)
nmap("<Leader>fc", '<Cmd>lua require("internal.fuzzy").commands()<CR>')
command.add(
	'lua require("internal.fuzzy").find({ search_type = "directory", prompt = "Directories" })',
	"Find a directory",
	with_default_fuzzy_opts("<Leader>fd")
)
command.add(
	'lua require("internal.fuzzy").find()',
	"Find a file",
	with_default_fuzzy_opts("<Leader>ff")
)
command.add(
	'lua require("internal.fuzzy").git_diff()',
	"Find a modified file",
	with_default_fuzzy_opts("<Leader>fg")
)
command.add(
	'lua require("internal.fuzzy").oldfiles()',
	"Find a recent file",
	with_default_fuzzy_opts("<Leader>fh")
)
command.add(
	'lua require("internal.fuzzy").terminals()',
	"Find a running terminal",
	with_default_fuzzy_opts("<Leader>ft")
)
command.add(
	'lua require("internal.fuzzy").cword_file_line()',
	'Find "file:line:column" under cursor',
	with_default_fuzzy_opts("<Leader>fw")
)

-- Searching.
local with_default_search_opts = command_util.create_factory({ group = "Search" })

command.add(
	'lua require("internal.search").rg_smart_case()',
	"Search for word",
	with_default_search_opts("<Leader>sf")
)
command.add(
	'lua require("internal.search").git_grep()',
	"Search for word using Git",
	with_default_search_opts("<Leader>sg")
)
command.add(
	'lua require("internal.search").rg_word()',
	"Search for word under cursor",
	with_default_search_opts("<Leader>sw")
)
command.add(
	'lua require("internal.search").rg_word({ WORD = true })',
	"Search for WORD under cursor",
	with_default_search_opts("<Leader>sW")
)

-- Terminal.
local with_default_term_opts = command_util.create_factory({ group = "Terminal" })
local tags = command.tags
local term_desc = "Create a new terminal instance"

command.add(
	'lua require("internal.terminal").create()',
	term_desc,
	with_default_term_opts("<Leader>tn")
)
command.add(
	'lua require("internal.terminal").create_horizontal()',
	term_desc,
	with_default_term_opts("<Leader>ts", tags.horizontal)
)
command.add(
	'lua require("internal.terminal").create_tab()',
	term_desc,
	with_default_term_opts("<Leader>tt", tags.tab)
)
command.add(
	'lua require("internal.terminal").create_vertical()',
	term_desc,
	with_default_term_opts("<Leader>tv", tags.vertical)
)
