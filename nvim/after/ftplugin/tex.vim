set conceallevel=0

set textwidth=78
set wrap

inoremap <buffer> <C-B> <ESC>yypkI\begin{<ESC>A}<ESC>jI\end{<ESC>A}<esc>kA<CR>

call vimtex#imaps#add_map({
			\ 'lhs' : '.',
			\ 'rhs' : '\ldots',
			\})
