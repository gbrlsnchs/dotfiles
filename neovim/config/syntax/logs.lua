if vim.b.current_syntax then
	return
end

vim.cmd([[
syntax match logsDate /^\d\+\/\d\+\/\d\+ \d\+:\d\+:\d\+/
syntax match logsError /ERROR/
syntax match logsWarn /WARN/
syntax match logsInfo /INFO/
syntax match logsDebug /DEBUG/
syntax match logsTrace /TRACE/

highlight def link logsDate LineNr
highlight def link logsError DiagnosticError
highlight def link logsWarn DiagnosticWarn
highlight def link logsInfo DiagnosticInfo
highlight def link logsDebug DiagnosticHint
highlight def link logsTrace DiagnosticHint
]])

vim.b.current_syntax = "logs"
