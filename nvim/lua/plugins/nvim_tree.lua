local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
	return
end

local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	vim.keymap.set("n", "<CR>", function()
		local node = api.tree.get_node_under_cursor()
		if vim.fn.isdirectory(node.absolute_path) == 1 then
			return api.tree.change_root_to_node(node)
		else
			return api.node.open.edit(node)
		end
	end, opts("edit_cd"))

	vim.keymap.set("n", "q", api.tree.close, opts("Close"))
	vim.keymap.set("n", "<Esc>", api.tree.close, opts("Close"))
	vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<Right>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "<Left>", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "a", api.fs.create, opts("Create"))
	vim.keymap.set("n", "i", api.fs.rename, opts("Rename"))
	vim.keymap.set("n", "dd", api.fs.remove, opts("Delete"))
	vim.keymap.set("n", "++", api.node.navigate.git.next, opts("Next Git"))
	vim.keymap.set("n", "--", api.node.navigate.git.prev, opts("Prev Git"))
	vim.keymap.set("n", "o", api.node.open.preview, opts("Open Preview"))
	vim.keymap.set("n", "za", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
	vim.keymap.set("n", "zi", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
	vim.keymap.set("n", "K", api.node.show_info_popup, opts("Info"))
	vim.keymap.set("n", "yf", api.fs.copy.filename, opts("Copy Name"))
	vim.keymap.set("n", "yp", api.fs.copy.relative_path, opts("Copy Relative Path"))
end

nvim_tree.setup({
	view = { adaptive_size = true, side = "right" },
	update_focused_file = { enable = true },
	on_attach = on_attach,

	---markers
	renderer = {
		indent_markers = { enable = true },
		indent_width = 2,
		special_files = {},
	},
	diagnostics = { enable = false },
	git = { enable = false },
	filters = { dotfiles = true, custom = { "^__pycache__" } },
})
