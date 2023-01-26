local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
	return
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.4

local function edit_cd(node)
	local api = require("nvim-tree.api")
	if vim.fn.isdirectory(node.absolute_path) == 1 then
		return api.tree.change_root_to_node(node)
	else
		return api.node.open.edit(node)
	end
end

nvim_tree.setup({
	update_focused_file = { enable = true },

	remove_keymaps = true,

	---window
	view = {
		mappings = {
			list = {
				{ key = "<CR>", action = "edit_cd", action_cb = edit_cd },
				{ key = { "q", "<Esc>" }, action = "close" },
				{ key = { "l", "<Right>" }, action = "edit" },
				{ key = { "h", "<Left>" }, action = "close_node" },
				{ key = "a", action = "create" },
				{ key = "i", action = "rename" },
				{ key = "dd", action = "remove" },
				{ key = "++", action = "next_git_item" },
				{ key = "--", action = "prev_git_item" },
				{ key = "o", action = "preview" },
				{ key = "za", action = "toggle_dotfiles" },
				{ key = "zi", action = "toggle_git_ignored" },
				{ key = "K", action = "toggle_file_info" },
				{ key = "yf", action = "copy_name" },
				{ key = "yp", action = "copy_path" },
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

	---markers
	renderer = {
		indent_markers = { enable = true },
		indent_width = 2,
		special_files = {},
	},
	diagnostics = { enable = false },
	git = { enable = false },
	filters = { dotfiles = true },
})
