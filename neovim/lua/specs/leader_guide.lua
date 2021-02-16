local M = {'spinks/vim-leader-guide'}

M.config = function()
	vim.g.mapleader = ' '
	vim.g.lmap = {
		b = {
			name = 'buffers',
			['?'] = 'fzf-buffers',
			d = 'buffer-delete',
			D = 'buffer-delete-stay',
			l = 'fzf-buffer-lines',
			n = 'next-buffer',
			p = 'previous-buffer',
		},
		f = {
			name = 'files',
			['?'] = 'fzf-ripgrep',
			f = 'fzf-files',
			g = 'fzf-git-files',
			p = 'fzf-ripgrep-prompt', -- TODO: use vim.fn.prompt!
		},
		g = {
			name = 'git',
			r = 'reset-hunk',
			s = 'stage-hunk',
			p = 'preview-hunk',
			u = 'undo-stage-hunk',
		},
		l = {
			name = 'lsp',
			c = 'lsp-code-action',
			d = {
				name = 'lsp-diagnostics',
				n = 'next-diagnostic',
				p = 'previous-diagnostic',
				s = 'show-line-diagnostics',
			},
			f = 'lsp-format',
			r = 'lsp-rename',
		},
		t = {
			name = 'terminal',
			n = 'new-terminal',
			s = 'split-terminal',
			v = 'vsplit-terminal',
			t = 'tabnew-terminal',
		},
	}

	vim.fn['leaderGuide#register_prefix_descriptions'](' ', 'g:lmap')

	local set_keymap = vim.api.nvim_set_keymap
	local map_opts = { silent = true, noremap = true }

	set_keymap('n', '<Leader>', ":<C-u>LeaderGuide ' '<CR>", map_opts)

	local lsp_cmd_name = require('utils.lsp').cmd_name
	local cmds = {
		-- Buffers
		['b?'] = '<Cmd>Buffers<CR>',
		bd = '<Cmd>bdelete<CR>',
		bD = '<Cmd>Bdelete<CR>',
		bl = '<Cmd>BLines<CR>',
		bn = '<Cmd>bnext<CR>',
		bp = '<Cmd>bprevious<CR>',

		-- Files
		['f?'] = '<Cmd>Rg<CR>',
		ff = '<Cmd>Files<CR>',
		fg = '<Cmd>GitFiles<CR>',
		fp = ':Rg ',

		-- Git
		gr = "<Cmd>lua require('gitsigns').reset_hunk()",
		gs = "<Cmd>lua require('gitsigns').stage_hunk()",
		gp = "<Cmd>lua require('gitsigns').preview_hunk()",
		gu = "<Cmd>lua require('gitsigns').undo_hunk()",

		-- LSP
		lc = lsp_cmd_name('code_action'),
		ldn = '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
		ldp = '<Cmd>lua vim.lsp.diagnostic.goto_previous()<CR>',
		lds = '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
		lf = lsp_cmd_name('formatting'),
		lr = lsp_cmd_name('rename'),

		-- Terminal
		tn = '<Cmd>terminal<CR>',
		ts = '<Cmd>split +terminal<CR>',
		tv = '<Cmd>vsplit +terminal<CR>',
		tt = '<Cmd>tabnew +terminal<CR>',
	}

	for map, cmd in pairs(cmds) do
		set_keymap('n', string.format('<Leader>%s', map), cmd, { noremap = true })
	end
end

return M
