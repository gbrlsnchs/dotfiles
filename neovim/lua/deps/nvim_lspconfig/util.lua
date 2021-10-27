local M = {}

local extensions = {}
local attachments = {}

function M.register_extension(fn)
	table.insert(extensions, fn)
end

function M.register_attachment(fn)
	table.insert(attachments, fn)
end

function M.on_attach(client, bufnr)
	for _, on_attach in ipairs(attachments) do
		on_attach(client, bufnr)
	end

	for _, ext in ipairs(extensions) do
		ext(bufnr)
	end
end

return M
