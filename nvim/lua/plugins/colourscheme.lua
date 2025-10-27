local osaka_ok, _ = pcall(require, "solarized-osaka")
if not osaka_ok then
	return
end

local M = {}

M.opts = {
	transparent = true,
	on_highlights = function(highlights, colors)
		highlights["@lsp.type.constant"] = { link = "@constant" }
		highlights["@lsp.type.package"] = { link = "@module" }
		highlights["@lsp.type.module"] = { link = "@module" }
		highlights["@lsp.type.array"] = { link = "@comment.todo" }
		highlights["@lsp.type.object"] = { fg = "#b02669" }
		highlights["@markup.heading.1"] = { link = "DiagnosticVirtualTextInfo" }
		highlights["@markup.heading.2"] = { link = "DiagnosticVirtualTextHint" }
		highlights["@markup.heading.3"] = { link = "DiagnosticVirtualTextWarn" }
		highlights.Visual = { bg = "#214283" }
		highlights.NormalFloat = { link = "Normal" }
		highlights.WinBarNC = { link = "WinBar" }
		highlights.CursorLine = { link = "CursorColumn" }
		highlights.FloatBorder = { link = "@comment.todo" }
		highlights.FloatTitle = { link = "Normal" }
		highlights.LspInlayHint = { link = "Comment" }
		highlights.TreesitterContext = { link = "Pmenu" }
		highlights.ErrorMsg = { bold = false, fg = "#dc322f", bg = "none" }
		highlights.DiagnosticOk = { bold = false, ctermfg = 1, fg = "LightGreen" }
		highlights.DiagnosticSignOk = { link = "DiagnosticOk" }
		highlights.DiagnosticError = { bold = false, ctermfg = 1, fg = "Red" }
		highlights.DiagnosticSignError = { link = "DiagnosticError" }
		highlights.DiagnosticWarn = { bold = false, ctermfg = 1, fg = "Orange" }
		highlights.DiagnosticSignWarn = { link = "DiagnosticWarn" }
		highlights.DiagnosticVirtualTextError = { bg = "#331423", fg = "#db302d" }
		highlights.DiffAdd = { bg = "#0c4c44" }
		highlights.DiffDelete = { bg = "#331423" }
		highlights.DiffChange = { bg = "#664c00" }
		highlights.DiffText = { fg = "#331423", bg = "#664c00" }
		highlights.WinSeparator = { bold = false, fg = "#268bd2", bg = "none" }
		highlights.MatchWord = { bold = false, reverse = true }
		highlights.MatchParen = { bold = false, reverse = true }
		highlights.MatchupVirtualText = { bold = false, reverse = true }
	end,
	styles = {
		keywords = { italic = false },
		sidebars = "transparent",
		floats = "transparent",
	},
	sidebars = { "qf", "help" },
	day_brightness = 0,
}

return M
