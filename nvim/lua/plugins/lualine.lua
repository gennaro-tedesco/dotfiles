local line_ok, lualine = pcall(require, "lualine")
if not line_ok then
	return
end

local noice_ok, noice = pcall(require, "noice")
if not noice_ok then
	return
end

local icons = require("utils").icons

local function is_split()
	return vim.api.nvim_win_get_height(0) ~= vim.go.lines - 1 or vim.api.nvim_win_get_width(0) ~= vim.go.columns
end

local exclude_ft = {
	"NvimTree",
	"help",
	"Outline",
}

local soldark = require("lualine.themes.solarized_dark")
soldark.normal.a.gui = ""
soldark.insert.a.gui = ""
soldark.visual.a.gui = ""
lualine.setup({
	extensions = { "quickfix", "fugitive", "symbols-outline", "nvim-tree", "lazy" },
	options = {
		theme = soldark,
		component_separators = { left = "", right = "" },
		disabled_filetypes = { statusline = { "alpha" } },
	},
	sections = {
		lualine_a = { { "mode", padding = { left = 1 } } },
		lualine_b = { "branch" },
		lualine_c = {
			{ "filename", path = 1 },
			{
				"diff",
				on_click = function()
					require("gitsigns").setloclist()
				end,
			},
			{
				require("nvim-possession").status,
				cond = function()
					return require("nvim-possession").status() ~= nil
				end,
			},
		},
		lualine_x = {
			{
				require("lazy.status").updates,
				cond = require("lazy.status").has_updates,
				color = { fg = "#2aa198" },
				on_click = function()
					require("lazy").home()
				end,
			},
			{
				noice.api.status.mode.get,
				cond = noice.api.status.mode.has,
				color = { fg = "#2aa198" },
			},
			{
				"diagnostics",
				update_in_insert = true,
				symbols = {
					error = icons.statusline.Error,
					warn = icons.statusline.Warn,
					info = icons.statusline.Info,
					hint = icons.statusline.Hint,
				},
				colored = false,
				on_click = function()
					vim.diagnostic.setloclist()
				end,
			},
			{ "filetype" },
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	winbar = {
		lualine_x = {
			{
				"filename",
				cond = function()
					return is_split() and not require("utils").is_in_list(vim.bo.filetype, exclude_ft)
				end,
			},
		},
	},
	inactive_winbar = {
		lualine_x = {
			{
				"filename",
				cond = function()
					return is_split() and not require("utils").is_in_list(vim.bo.filetype, exclude_ft)
				end,
			},
		},
		lualine_y = {
			{
				"progress",
				cond = function()
					return is_split() and not require("utils").is_in_list(vim.bo.filetype, exclude_ft)
				end,
			},
		},
	},
})
