vim.wo.conceallevel = 0
vim.opt.textwidth = 78

vim.keymap.set("i", "//", "\\")

vim.api.nvim_exec(
	[[
	call vimtex#imaps#add_map({
				\ 'lhs' : '.',
				\ 'rhs' : '\ldots',
				\ 'wrapper' : 'vimtex#imaps#wrap_trivial',
				\})

	call vimtex#imaps#add_map({
				\ 'lhs' : 'v',
				\ 'rhs' : '\verb++<Left>',
				\ 'wrapper' : 'vimtex#imaps#wrap_trivial',
				\})
	]],
	false
)
