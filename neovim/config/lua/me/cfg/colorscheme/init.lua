local util = require("me.api.util")
local palette = require("me.cfg.colorscheme.palette")

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
	syntax = {
		variable = { fg = palette.bright_gray },
		special = { fg = palette.bright_cyan },
		type = { fg = palette.bright_cyan, bold = true },
		constant = { fg = palette.bright_blue },
		["function"] = { fg = palette.bright_purple, bold = true },
		boolean = { fg = palette.purple, bold = true, italic = true },
		number = { fg = palette.bright_blue },
		string = { fg = palette.bright_yellow },
		comment = { fg = palette.bright_black, italic = true },
		operator = { fg = palette.bright_gray },
		keyword = { fg = palette.red, bold = true },
		include = { fg = palette.yellow, bold = true },
		parameters = { fg = palette.bright_gray, italic = true },
	},
}

local common_hl = {
	Normal = { bg = palette.bg, fg = palette.fg },
	NormalFloat = { bg = palette.bg, fg = palette.fg },

	Float = { bg = palette.bg, fg = palette.fg },
	FloatBorder = { bg = palette.bg, fg = palette.fg },

	Visual = { bg = palette.blue, fg = palette.black },
	VisualNOS = { bg = palette.blue, fg = palette.black },

	ColorColumn = { bg = palette.black },
	SignColumn = { bg = palette.bg, fg = palette.fg },
	LineNr = { fg = palette.gray },
	VertSplit = { bg = palette.bg },
	WinSeparator = { fg = palette.black },

	Cursor = { reverse = true },
	CursorLine = { bg = palette.black },
	CursorLineNr = { fg = palette.bright_gray },

	Search = { bg = palette.yellow, fg = palette.bg },
	IncSearch = { bg = palette.cyan, fg = palette.bg },

	MatchParen = { underline = true },
	NonText = { fg = palette.bright_black },
	Whitespace = { fg = palette.black },
	Question = { bg = palette.bright_black },
	MoreMsg = { bg = palette.bg, fg = palette.fg },
	Directory = { fg = palette.bright_yellow, bold = true },

	QuickFixLine = { bg = palette.black, bold = true },

	Pmenu = { bg = palette.black, fg = palette.gray },
	PmenuSel = { bg = palette.bright_blue, fg = palette.bg, bold = true },
	PmenuSbar = { bg = palette.bright_black },
	PmenuThumb = { bg = palette.yellow },
}

local diagnostics_hl = {
	WarningMsg = { fg = commons.diagnostic.warn, sp = commons.diagnostic.warn },
	DiagnosticWarn = { fg = commons.diagnostic.warn, sp = commons.diagnostic.warn },
	DiagnosticSignWarn = { bg = palette.bg, fg = commons.diagnostic.warn },
	DiagnosticUnderlineWarn = {
		bg = palette.black,
		fg = commons.diagnostic.warn,
		sp = commons.diagnostic.warn,
		undercurl = true,
	},

	Error = { fg = commons.diagnostic.error, sp = commons.diagnostic.error },
	ErrorMsg = { fg = commons.diagnostic.error, sp = commons.diagnostic.error },
	DiagnosticError = { fg = commons.diagnostic.error, sp = commons.diagnostic.error },
	DiagnosticSignError = { bg = palette.bg, fg = commons.diagnostic.error },
	DiagnosticUnderlineError = {
		bg = palette.black,
		fg = commons.diagnostic.error,
		undercurl = true,
		sp = commons.diagnostic.error,
	},

	DiagnosticInfo = { fg = commons.diagnostic.info, sp = commons.diagnostic.info },
	DiagnosticSignInfo = { bg = palette.bg, fg = palette.bright_blue },
	DiagnosticUnderlineInfo = {
		bg = palette.black,
		fg = commons.diagnostic.info,
		undercurl = true,
		sp = commons.diagnostic.info,
	},

	DiagnosticHint = { fg = commons.diagnostic.hint, sp = palette.bright_purple },
	DiagnosticSignHint = { bg = palette.bg, fg = palette.bright_purple },
	DiagnosticUnderlineHint = {
		bg = palette.black,
		fg = commons.diagnostic.hint,
		undercurl = true,
		sp = commons.diagnostic.hint,
	},
}

local bars_hl = {
	StatusLine = { bg = palette.black, fg = palette.gray },
	StatusLineNC = { bg = palette.black },
	StatusLineBranch = { bg = palette.black, fg = palette.bright_purple, bold = true },
	StatusLineDiffAdd = { bg = commons.diff.add, fg = palette.bg },
	StatusLineDiffChange = { bg = commons.diff.change, fg = palette.bg },
	StatusLineDiffDelete = { bg = commons.diff.delete, fg = palette.bg },
	StatusLineLSPServer = { bg = palette.bg, fg = palette.green, bold = true },
	StatusLineLSPError = {
		bg = commons.diagnostic.error,
		fg = palette.bg,
		sp = commons.diagnostic.error,
	},
	StatusLineLSPWarn = {
		bg = commons.diagnostic.warn,
		fg = palette.bg,
		sp = commons.diagnostic.warn,
	},
	StatusLineLSPInfo = {
		bg = commons.diagnostic.info,
		fg = palette.bg,
		sp = commons.diagnostic.info,
	},
	StatusLineLSPHint = {
		bg = commons.diagnostic.hint,
		fg = palette.bg,
		sp = palette.bright_purple,
	},
	StatusLineNotificationError = { bg = commons.diagnostic.error, fg = palette.bg },
	StatusLineNotificationWarn = { bg = commons.diagnostic.warn, fg = palette.bg },
	StatusLineNotificationInfo = { bg = commons.diagnostic.info, fg = palette.bg },
	StatusLineNotificationDebug = { bg = commons.diagnostic.hint, fg = palette.bg },
	StatusLineNotificationTrace = { bg = commons.diagnostic.hint, fg = palette.bg },

	StatusLinePolyfill = { bg = palette.bg },

	TabLine = {},
	TabLineFill = {},

	WinBar = { bg = palette.bg, fg = palette.bright_gray },
	WinBarNC = { bg = palette.bg },
	WinBarFileInfo = { bg = palette.bg, fg = palette.bright_gray, bold = true },
	WinBarFileInfoModified = {
		bg = palette.bg,
		fg = palette.bright_gray,
		bold = true,
		underline = true,
	},
	WinBarNCFileInfo = { bg = palette.bg, fg = palette.gray, bold = true },
	WinBarNCFileInfoModified = {
		bg = palette.bg,
		fg = palette.gray,
		bold = true,
		underline = true,
	},
	WinBarLSPServer = { bg = palette.bg, fg = palette.green, bold = true },
	WinBarLSPError = {
		bg = palette.bg,
		fg = commons.diagnostic.error,
		sp = commons.diagnostic.error,
	},
	WinBarLSPWarn = { bg = palette.bg, fg = commons.diagnostic.warn, sp = commons.diagnostic.warn },
	WinBarLSPInfo = { bg = palette.bg, fg = commons.diagnostic.info, sp = commons.diagnostic.info },
	WinBarLSPHint = { bg = palette.bg, fg = commons.diagnostic.hint, sp = palette.bright_purple },
}

local syntax_hl = {
	Special = commons.syntax.special,
	SpecialChar = commons.syntax.special,
	SpecialKey = commons.syntax.special,
	Type = commons.syntax.type,
	Constant = commons.syntax.constant,
	Function = commons.syntax["function"],
	Boolean = commons.syntax.boolean,
	Number = commons.syntax.number,
	String = commons.syntax.string,
	Comment = commons.syntax.comment,
	Operator = commons.syntax.operator,
	Keyword = commons.syntax.keyword,
	Conditional = commons.syntax.keyword,
	Repeat = commons.syntax.keyword,
	Include = commons.syntax.include,
	PreProc = commons.syntax.special,
}

-- TODO: Add missing highlights.
local tree_sitter_hl = {
	TSNone = {},
	TSPunctSpecial = commons.syntax.special,
	TSPunctBracket = commons.syntax.variable,
	TSVariable = commons.syntax.variable,
	TSVariableBuiltin = { fg = palette.bright_blue, italic = true },
	TSAttribute = commons.syntax.variable,
	TSProperty = commons.syntax.variable,
	TSField = commons.syntax.variable,
	TSParameter = commons.syntax.parameters,
	TSParameterReference = commons.syntax.parameters,
	TSType = commons.syntax.type,
	TSTypeBuiltin = commons.syntax.type,
	TSConstant = commons.syntax.constant,
	TSConstBuiltin = util.tbl_merge(commons.syntax.constant, { bold = true, italic = true }),
	TSFunction = commons.syntax["function"],
	TSFuncBuiltin = commons.syntax["function"],
	TSMethod = commons.syntax["function"],
	TSBoolean = commons.syntax.boolean,
	TSString = commons.syntax.string,
	TSNumber = commons.syntax.number,
	TSLiteral = commons.syntax.string,
	TSComment = commons.syntax.comment,
	TSOperator = commons.syntax.operator,
	TSKeyword = commons.syntax.keyword,
	TSKeywordFunction = util.tbl_merge(commons.syntax.keyword, { bold = true, italic = true }),
	TSKeywordOperator = commons.syntax.variable,
	TSConditional = commons.syntax.keyword,
	TSRepeat = commons.syntax.keyword,
	TSNamespace = commons.syntax.special,
	TSInclude = util.tbl_merge(commons.syntax.keyword, { bold = true }),
	TreesitterContext = { bg = palette.black },
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
