local session = require("lib.session")

if not session.init() then
	session.close()
	return
end

vim.cmd([[
augroup database
	autocmd!
	autocmd VimLeavePre * lua require("lib.session").close()
augroup END
]])
