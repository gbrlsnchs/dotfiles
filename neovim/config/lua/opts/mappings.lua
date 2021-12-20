local command = require("lib.command")

vim.g.mapleader = " "

local function nmap(key, cmd)
	vim.api.nvim_set_keymap("n", key, cmd, { noremap = true })
end

-- Buffers.
nmap("]b", "<Cmd>bnext<CR>")
nmap("[b", "<Cmd>bNext<CR>")
nmap("<Leader>bD", "<Cmd>bdelete<CR>")
nmap("<Leader>bd", "<Cmd>Bdelete<CR>")
nmap("<Leader>bW", "<Cmd>bwipeout<CR>")
nmap("<Leader>bw", "<Cmd>Bwipeout<CR>")

-- Loclist/quickfix.
nmap("]l", "<Cmd>lnext<CR>")
nmap("[l", "<Cmd>lprevious<CR>")
nmap("]q", "<Cmd>cnext<CR>")
nmap("[q", "<Cmd>cprevious<CR>")

-- Fuzzy finding.
local fuzzy_group = "Fuzzy"

nmap("<Leader>f.", '<Cmd>lua require("internal.fuzzy").find({ use_file_cwd = true })<CR>')
nmap("<Leader>fb", '<Cmd>lua require("internal.fuzzy").buffers()<CR>')
nmap("<Leader>fc", '<Cmd>lua require("internal.fuzzy").commands()<CR>')
nmap(
	"<Leader>fd",
	'<Cmd>lua require("internal.fuzzy").find({ search_type = "directory", prompt = "Directories" })<CR>'
)
nmap("<Leader>ff", '<Cmd>lua require("internal.fuzzy").find()<CR>')
nmap("<Leader>fg", '<Cmd>lua require("internal.fuzzy").git_diff()<CR>')
command.add('lua require("internal.fuzzy").oldfiles()', "Find recent files", {
	group = fuzzy_group,
	keymap = { mode = "n", keys = "<Leader>fh" },
})
nmap("<Leader>ft", '<Cmd>lua require("internal.fuzzy").terminals()<CR>')
nmap("<Leader>fw", '<Cmd>lua require("internal.fuzzy").cword_file_line()<CR>')

-- Searching.
nmap("<Leader>sf", '<Cmd>lua require("internal.search").rg_smart_case()<CR>')
nmap("<Leader>sg", '<Cmd>lua require("internal.search").git_grep()<CR>')
nmap("<Leader>sw", '<Cmd>lua require("internal.search").rg_word()<CR>')
nmap("<Leader>sW", '<Cmd>lua require("internal.search").rg_word({ WORD = true })<CR>')

-- Terminal.
nmap("<Leader>tn", '<Cmd>lua require("internal.terminal").create()<CR>')
nmap("<Leader>ts", '<Cmd>lua require("internal.terminal").create_horizontal()<CR>')
nmap("<Leader>tt", '<Cmd>lua require("internal.terminal").create_tab()<CR>')
nmap("<Leader>tv", '<Cmd>lua require("internal.terminal").create_vertical()<CR>')
