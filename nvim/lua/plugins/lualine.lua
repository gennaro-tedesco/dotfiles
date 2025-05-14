local line_ok, lualine = pcall(require, "lualine")
if not line_ok then
	return
end

local icons = require("utils").icons
local clients_lsp = require("utils").clients_lsp

local soldark = require("lualine.themes.solarized_dark")
soldark.normal.a.gui = ""
soldark.insert.a.gui = ""
soldark.visual.a.gui = ""
lualine.setup({
	extensions = { "nvim-tree", "lazy" },
	options = {
		theme = soldark,
		component_separators = { left = "", right = "" },
		disabled_filetypes = { "snacks_dashboard" },
	},
	sections = {
		lualine_a = { { "mode", padding = { left = 1 } } },
		lualine_b = {
			{
				"branch",
				fmt = function(str)
					vim.g._branch_name = str
					local maxlen = 30
					if #str > maxlen then
						return str:sub(1, maxlen - 3) .. "..."
					end
					return str
				end,
				on_click = function()
					local branch = vim.g._branch_name or "<no branch>"
					vim.notify(
						branch,
						vim.log.levels.INFO,
						{ style = "compact", title = "  git branch", id = "branch" }
					)
				end,
			},
		},
		lualine_c = {
			{
				"filename",
				path = 1,
				on_click = function()
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
					vim.notify(
						filename,
						vim.log.levels.INFO,
						{ style = "compact", title = "filename", id = "filename" }
					)
				end,
			},
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
			{ clients_lsp },
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
})
