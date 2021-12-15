local M = {}

local extensions = {}
local attachments = {}

local local_settings_file = "neovim.json"

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

function M.get_local_settings()
	local local_settings
	if not local_settings and vim.fn.filereadable(local_settings_file) == 1 then
		-- local uv = async.uv
		-- local _, fd = uv.fs_open(local_settings_file, "r", 438)
		-- local _, stat = uv.fs_stat(fd)
		-- local _, data = uv.fs_read(fd, stat.size, 0)
		-- uv.fs_close(fd)

		local data = vim.fn.join(vim.fn.readfile(local_settings_file))
		local_settings = vim.fn.json_decode(data)
	end
	return local_settings
end

return M
