local api = vim.api

local M = {}

--- Merges custom options with defaults, always giving preference for custom options.
--- @param custom_opts table: Custom options.
--- @param defaults table: Defaults to be applied to fields in case they're not present in custom options.
--- @return table: Properly merged options table.
function M.tbl_merge(custom_opts, defaults)
	return vim.tbl_deep_extend("keep", custom_opts or {}, defaults)
end

--- Wraps a function in order to make it receive arguments from <f-args> from an ex command.
--- @return function: Wrapped function that receives <f-args>.
function M.with_fargs(fn)
	return function(cmd)
		cmd = cmd or {}
		local fargs = cmd.fargs

		if fargs and #fargs == 1 then
			return fn(fargs[1])
		end

		return fn(fargs)
	end
end

--- Wraps a function in order to make it receive arguments from <range> from an ex command.
--- @return: function: Wrapped function that receives <range>.
function M.with_range(fn)
	return function(cmd)
		cmd = cmd or {}
		local range = cmd.range

		if range == 1 then
			return fn({ cmd.line1 })
		end

		if range == 2 then
			return fn({ cmd.line1, cmd.line2 })
		end

		return fn()
	end
end

--- Get the base directory of a buffer based on its ID.
--- @param bufnr number: ID of the buffer.
--- @param default string: Default value when the buffer name cannot be retrieved.
function M.get_buf_base_dir(bufnr, default)
	local buf_name = api.nvim_buf_get_name(bufnr)
	if buf_name:len() == 0 then
		return default
	end

	if vim.fn.isdirectory(buf_name) == 0 then
		buf_name = vim.fn.fnamemodify(buf_name, ":h")
	end
	return vim.fn.fnamemodify(buf_name, ":~:.")
end

--- Loads a Vim package by calling 'packadd'.
--- @param pkg string: Name of the package to be loaded.
function M.packadd(pkg)
	vim.cmd(string.format("packadd %s", pkg))
end

return M
