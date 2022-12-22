vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.4

require("nvim-tree").setup({
	remove_keymaps = { "<Tab>", "D", "d", "s", "r" },
	renderer = { icons = { show = { file = false } } },
	diagnostics = { enable = false },
	view = {
		mappings = {
			list = {
				{ key = "i", action = "rename" },
				{ key = "dd", action = "remove" },
				{ key = "++", action = "next_git_item" },
				{ key = "--", action = "prev_git_item" },
				{ key = "o", action = "preview" },
			},
		},
		float = {
			enable = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * WIDTH_RATIO
				local window_h = screen_h * HEIGHT_RATIO
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
				return {
					border = "rounded",
					relative = "editor",
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		},
		width = function()
			return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
		end,
	},
	filters = {
		dotfiles = true,
	},
})
