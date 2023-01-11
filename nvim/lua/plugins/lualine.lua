local line_ok, lualine = pcall(require, "lualine")
if not line_ok then
	return
end

local noice_ok, noice = pcall(require, "noice")
if not noice_ok then
	return
end

local soldark = require("lualine.themes.solarized_dark")
soldark.normal.a.gui = ""
soldark.insert.a.gui = ""
soldark.visual.a.gui = ""
lualine.setup({
	extensions = { "quickfix", "fugitive", "symbols-outline", "nvim-tree" },
	options = {
		theme = soldark,
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", padding = { left = 1 } } },
		lualine_b = { "branch" },
		lualine_c = { { "filename", path = 1 }, { "require'nvim-possession'.status()" } },
		lualine_x = {
			{
				require("lazy.status").updates,
				cond = require("lazy.status").has_updates,
				color = { fg = "#2aa198" },
			},
			{
				noice.api.status.mode.get,
				cond = noice.api.status.mode.has,
				color = { fg = "#2aa198" },
			},
			{
				"diagnostics",
				update_in_insert = true,
				symbols = { error = "❗:", warn = "⚠️ :", info = "i:", hint = "💡:" },
				colored = false,
			},
			{ "filetype" },
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
