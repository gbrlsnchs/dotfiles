local function wrap_handler(method, opts)
	local fn = vim.lsp.handlers[method]

	vim.lsp.handlers[method] = vim.lsp.with(fn, opts)
end

wrap_handler("textDocument/hover", { border = "single" })
wrap_handler("textDocument/signatureHelp", { border = "single" })
