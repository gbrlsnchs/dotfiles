local uv = vim.loop

local M = {}

--- Reads a file at 'path'. Is blocking.
--- @param path string: The path of the file to be read.
--- @return string|nil: Content of the file that has been read.
function M.read_file(path)
	-- TODO: Plug in notification system.
	local fd = uv.fs_open(path, "r", 483)
	if not fd then
		return nil
	end

	local stat = uv.fs_fstat(fd)
	if not stat then
		return nil
	end

	local data = uv.fs_read(fd, stat.size, 0)

	assert(uv.fs_close(fd))

	return data
end

return M
