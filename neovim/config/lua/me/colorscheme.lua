local util = require("me.api.util")
local palette = require("me.colorscheme.palette")

local api = vim.api

local commons = {
	diff = {
		add = palette.green,
		change = palette.cyan,
		delete = palette.red,
	},
	diagnostic = {
		error = palette.bright_red,
		warn = palette.bright_yellow,
		info = palette.bright_blue,
		hint = palette.bright_purple,
	},
}

local common_hl = {
	Normal = { bg = palette.bg, fg = palette.fg },
	NormalFloat = { bg = palette.bg, fg = palette.fg },

	Float = { bg = palette.bg, fg = palette.fg },
	FloatBorder = { bg = palette.bg, fg = palette.fg },

	Visual = { bg = palette.blue, fg = palette.bg },
	VisualNOS = { bg = palette.blue, fg = palette.bg },

	ColorColumn = { bg = palette.black },
	SignColumn = { bg = palette.bg, fg = palette.fg },
	LineNr = { fg = palette.gray },
	VertSplit = { bg = palette.bg },
	WinSeparator = { fg = palette.black },

	Cursor = { reverse = true },
	CursorLine = { bg = palette.black },
	CursorLineNr = { fg = palette.bright_gray },

	Search = { bg = palette.cyan, fg = palette.bg },
	IncSearch = { bg = palette.bright_gray, fg = palette.bg },

	MatchParen = { underline = true },
	NonText = { fg = palette.bright_black },
	Whitespace = { fg = palette.bright_black },
	Question = { bg = palette.bright_black },
	MoreMsg = { bg = palette.bg, fg = palette.fg },
	Directory = { fg = palette.bright_yellow, bold = true },

	QuickFixLine = { bg = palette.bright_black, bold = true },

	Pmenu = { bg = palette.gray, fg = palette.bg },
	PmenuSel = { bg = palette.bright_blue, fg = palette.bg, bold = true },
	PmenuSbar = { bg = palette.bright_yellow },
	PmenuThumb = { bg = palette.yellow },
}

local diagnostics_hl = {
	WarningMsg = { fg = commons.diagnostic.warn, sp = commons.diagnostic.warn },
	DiagnosticWarn = { fg = commons.diagnostic.warn, sp = commons.diagnostic.warn },
	DiagnosticSignWarn = { bg = palette.bg, fg = commons.diagnostic.warn },
	DiagnosticUnderlineWarn = { bg = palette.black, fg = commons.diagnostic.warn, sp = commons.diagnostic.warn, undercurl = true },

	Error = { fg = commons.diagnostic.error, sp = commons.diagnostic.error },
	ErrorMsg = { fg = commons.diagnostic.error, sp = commons.diagnostic.error },
	DiagnosticError = { fg = commons.diagnostic.error, sp = commons.diagnostic.error },
	DiagnosticSignError = { bg = palette.bg, fg = commons.diagnostic.error },
	DiagnosticUnderlineError = { bg = palette.black, fg = commons.diagnostic.error, undercurl = true, sp = commons.diagnostic.error },

	DiagnosticInfo = { fg = commons.diagnostic.info, sp = commons.diagnostic.info },
	DiagnosticSignInfo = { bg = palette.bg, fg = palette.bright_blue },
	DiagnosticUnderlineInfo = { bg = palette.black, fg = commons.diagnostic.info, undercurl = true, sp = commons.diagnostic.info },

	DiagnosticHint = { fg = commons.diagnostic.hint, sp = palette.bright_purple },
	DiagnosticSignHint = { bg = palette.bg, fg = palette.bright_purple },
	DiagnosticUnderlineHint = { bg = palette.black, fg = commons.diagnostic.hint, undercurl = true, sp = commons.diagnostic.hint },
}

local bars_hl = {
	StatusLine = { bg = palette.black, fg = palette.gray },
	StatusLineNC = { bg = palette.black },
	StatusLineBranch = { bg = palette.black, fg = palette.bright_purple, bold = true },
	StatusLineDiffAdd = { bg = commons.diff.add, fg = palette.bg },
	StatusLineDiffChange = { bg = commons.diff.change, fg = palette.bg },
	StatusLineDiffDelete = { bg = commons.diff.delete, fg = palette.bg },
	StatusLineLSPServer = { bg = palette.bg, fg = palette.green, bold = true },
	StatusLineLSPError = { bg = commons.diagnostic.error, fg = palette.bg, sp = commons.diagnostic.error },
	StatusLineLSPWarn = { bg = commons.diagnostic.warn, fg = palette.bg, sp = commons.diagnostic.warn },
	StatusLineLSPInfo = { bg = commons.diagnostic.info, fg = palette.bg, sp = commons.diagnostic.info },
	StatusLineLSPHint = { bg = commons.diagnostic.hint, fg = palette.bg, sp = palette.bright_purple },
	StatusLineNotificationError = { bg = commons.diagnostic.error, fg = palette.bg },
	StatusLineNotificationWarn = { bg = commons.diagnostic.warn, fg = palette.bg },
	StatusLineNotificationInfo = { bg = commons.diagnostic.info, fg = palette.bg },
	StatusLineNotificationDebug = { bg = commons.diagnostic.hint, fg = palette.bg },
	StatusLineNotificationTrace = { bg = commons.diagnostic.hint, fg = palette.bg },

	StatusLinePolyfill = { bg = palette.bg },

	TabLine = {},
	TabLineFill = {},

	WinBar = { bg = palette.black, fg = palette.bright_gray },
	WinBarNC = { bg = palette.bg },
	WinBarFileInfo = { bg = palette.bg, fg = palette.bright_gray, bold = true },
	WinBarFileInfoModified = { bg = palette.bg, fg = palette.bright_gray, bold = true, underline = true },
	WinBarNCFileInfo = { bg = palette.bg, fg = palette.gray, bold = true },
	WinBarNCFileInfoModified = { bg = palette.bg, fg = palette.gray, bold = true, underline = true },
	WinBarLSPServer = { bg = palette.bg, fg = palette.green, bold = true },
	WinBarLSPError = { bg = palette.bg, fg = commons.diagnostic.error, sp = commons.diagnostic.error },
	WinBarLSPWarn = { bg = palette.bg, fg = commons.diagnostic.warn, sp = commons.diagnostic.warn },
	WinBarLSPInfo = { bg = palette.bg, fg = commons.diagnostic.info, sp = commons.diagnostic.info },
	WinBarLSPHint = { bg = palette.bg, fg = commons.diagnostic.hint, sp = palette.bright_purple },
}

local syntax_hl = {
	Special = { fg = palette.cyan },
	SpecialChar = { fg = palette.cyan },
	SpecialKey = { fg = palette.cyan },
	Type = { fg = palette.bright_cyan, bold = true },
	Constant = { fg = palette.bright_blue },
	Function = { fg = palette.bright_purple, bold = true },
	Boolean = { fg = palette.bright_red },
	Number = { fg = palette.bright_blue },
	String = { fg = palette.bright_green },
	Comment = { fg = palette.blue, italic = true },
	Operator = { fg = palette.cyan },
	Keyword = { fg = palette.yellow, bold = true },
	Conditional = { fg = palette.yellow, bold = true },
	Repeat = { fg = palette.yellow, bold = true },
	Include = { fg = palette.yellow, bold = true },
	PreProc = { fg = palette.cyan },
}

-- TODO: Add missing highlights.
local tree_sitter_hl = {
	TSNone = {},
	TSPunctSpecial = { fg = palette.cyan },
	TSVariable = { fg = palette.fg },
	TSVariableBuiltin = { fg = palette.bright_blue, italic = true },
	TSAttribute = { fg = palette.fg },
	TSProperty = { fg = palette.fg },
	TSField = { fg = palette.fg },
	TSParameter = { fg = palette.fg, italic = true },
	TSParameterReference = { fg = palette.fg, italic = true },
	TSType = { fg = palette.bright_cyan, bold = true },
	TSTypeBuiltin = { fg = palette.bright_cyan, bold = true, italic = true },
	TSConstant = { fg = palette.bright_blue },
	TSConstBuiltin = { fg = palette.bright_blue, bold = true, italic = true },
	TSFunction = { fg = palette.bright_purple, bold = true },
	TSFuncBuiltin = { fg = palette.bright_purple, bold = true },
	TSMethod = { fg = palette.bright_purple, bold = true },
	TSBoolean = { fg = palette.bright_red },
	TSString = { fg = palette.bright_green },
	TSNumber = { fg = palette.bright_blue },
	TSLiteral = { fg = palette.bright_green },
	TSComment = { fg = palette.blue, italic = true },
	TSOperator = { fg = palette.cyan },
	TSKeyword = { fg = palette.yellow, bold = true },
	TSKeywordFunction = { fg = palette.yellow, bold = true, italic = true },
	TSKeywordOperator = { fg = palette.fg },
	TSConditional = { fg = palette.yellow, bold = true },
	TSRepeat = { fg = palette.yellow, bold = true },
	TSNamespace = { fg = palette.cyan },
	TSInclude = { fg = palette.yellow, bold = true },
}

local diff_hl = {
	DiffText = { bg = palette.bg, fg = palette.fg },
	DiffAdd = { bg = palette.bg, fg = commons.diff.add },
	DiffChange = { bg = palette.bg, fg = commons.diff.change },
	DiffDelete = { bg = palette.bg, fg = commons.diff.delete },
	diffAdded = { bg = palette.bg, fg = commons.diff.add },
	diffChanged = { bg = palette.bg, fg = commons.diff.change },
	diffRemoved = { bg = palette.bg, fg = commons.diff.delete },
	diffFile = { fg = palette.bright_yellow, bold = true },
	diffNewFile = { fg = palette.bright_yellow, bold = true },
	diffLine = { fg = palette.bright_blue },
}

--- Sets the highlight group, which can be overriden by custom colors.
local function set_hl(groups, opts)
	for group_name, settings in pairs(groups) do
		api.nvim_set_hl(0, group_name, util.tbl_merge(opts, settings))
	end
end

local M = {}

--- Sets up the main colorscheme.
--- @param opts table: List of color groups and their values.
function M.setup(opts)
	local hl_groups = {
		common_hl,
		diagnostics_hl,
		bars_hl,
		syntax_hl,
		tree_sitter_hl,
		diff_hl,
	}

	for _, hl_group in ipairs(hl_groups) do
		set_hl(hl_group, opts)
	end
end

return M
