local util = require("lib.win")

local Builder = require("lib.statusline.builder")

local M = {}

local sline_bd = Builder
	:new()
	:add(function(is_active)
		local hl = (is_active and "StatusLineActive") or "StatusLineInactive"
		local fillchars = vim.opt.fillchars:get()

		return { { hl, fillchars.eob .. " " } }
	end)
	:add(function(is_active)
		local hl = is_active and "StatusLineActive" or "StatusLineInactive"

		if vim.bo.modified then
			return { { hl .. "FileInfoModified", "%f" } }
		end

		return { { hl .. "FileInfo", "%f" } }
	end)
	:add(function(is_active)
		local hl = is_active and "StatusLineActive" or "StatusLineInactive"

		return { { hl, " " } }
	end)
	:add(function(is_active)
		local branch = vim.b.gitsigns_head

		return is_active and branch and { { "StatusLineBranch", (" %s "):format(branch) } }
	end)
	:add(function(is_active)
		local status = vim.b.gitsigns_status_dict

		return is_active
			and status
			and {
				{ "StatusLineDiffAdd", (" +%d "):format(status.added or 0) },
				{ "StatusLineDiffChange", (" ~%d "):format(status.changed or 0) },
				{ "StatusLineDiffDelete", (" -%d "):format(status.removed or 0) },
			}
	end)
	:add(function(is_active)
		return { { is_active and "StatusLineActive" or "StatusLineInactive", "" } }
	end)

function M.build_statusline()
	local current_win = vim.api.nvim_get_current_win()
	local focused_win = util.get_focused_win()
	local statusline_type = current_win == focused_win and "active" or "inactive"

	return sline_bd:build(statusline_type)
end

return M
