local M = {}

M.orientations = {
	vertical = "vertical",
	horizontal = "horizontal",
	tabnew = "tabnew",
}

function M.list_orientations()
	return {
		M.orientations.vertical,
		M.orientations.horizontal,
		M.orientations.tabnew,
	}
end

return M
