local float_hl = vim.api.nvim_create_augroup("FloatHighlights", {})
vim.api.nvim_clear_autocmds({ group = float_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = float_hl,
	callback = function()
		vim.api.nvim_set_hl(0, "Floaterm", {})
		vim.api.nvim_set_hl(0, "Floaterm", { link = "Pmenu" })
	end,
})

vim.g.floaterm_autoclose = 2
vim.g.floaterm_keymap_toggle = "<F2>"
vim.g.floaterm_width = 0.85
vim.g.floaterm_height = 0.9
vim.g.floaterm_rootmarkers = { ".git" }
vim.g.floaterm_opener = "edit"
vim.g.floaterm_borderchars = "        "
vim.g.floaterm_title = ""
