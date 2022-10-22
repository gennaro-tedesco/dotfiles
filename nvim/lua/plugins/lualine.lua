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
	extensions = { "quickfix", "fugitive" },
	options = {
		theme = soldark,
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", padding = { left = 1 } } },
		lualine_b = { "branch" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {
			{
				noice.api.statusline.mode.get,
				cond = noice.api.statusline.mode.has,
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
