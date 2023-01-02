vim.wo.conceallevel = 0
vim.opt.textwidth = 78

inoremap("//", "\\")
inoremap("<C-b>", "<ESC>yypkI\\begin{<ESC>A}<ESC>jI\\end{<ESC>A}<esc>kA<CR>", { buffer = true })

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
