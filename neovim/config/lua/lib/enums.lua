local M = {}

M.orientations = {
	vertical = "vertical",
	horizontal = "horizontal",
	tabnew = "tabnew",
}

function M.list_orientations()
	return vim.tbl_keys(M.orientations)
end

return M
