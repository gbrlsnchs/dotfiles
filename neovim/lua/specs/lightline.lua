local M = {'itchyny/lightline.vim'}

M.requires = {'itchyny/vim-gitbranch'}

M.config = function()
	vim.cmd ([[
function! g:LightlineReadonly()
	return luaeval("require('functions.utils').lightline_readonly()")
endfunction

function! g:LightlineGitBranch()
	return luaeval("require('functions.utils').lightline_gitbranch()")
endfunction

function! g:LightlineGitHunks()
	return luaeval("require('functions.utils').lightline_githunks()")
endfunction

function! g:LightlineFilename()
	return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction
	]])

	vim.g.lightline = {
		enable = {
			statusline = true,
			tabline = true,
		},
		colorscheme = 'nord',
		active = {
			left = {
				{'mode', 'paste'},
				{'gitbranch', 'githunks', 'readonly', 'filename', 'modified'},
			},
			right = {
				{'lineinfo'},
				{'percent'},
				{'fileformat', 'fileencoding', 'filetype', 'charvaluehex'},
			},
		},
		component = {
			charvaluehex = '0x%B',
			lineinfo = '%-3l %-2v',
		},
		component_function = {
			gitbranch = 'LightlineGitBranch',
			githunks = 'LightlineGitHunks',
			readonly = 'LightlineReadonly',
			filename = 'LightlineFilename',
		},
		component_type = {
			buffers = 'tabsel',
		},
		separator = {
			left = "",
			right = "",
		},
		subseparator = {
			left = "",
			right = "",
		},
	}
end

return M
