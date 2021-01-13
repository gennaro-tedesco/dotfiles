" navigation controls when in diff mode
if &diff
	nnoremap <expr> <Right> '<C-W>l'
	nnoremap <expr> <Left> '<C-W>h'
	nnoremap <expr> <Down> ']c'
	nnoremap <expr> <Up> '[c'
	nnoremap <leader>q :wqa<cr>
endif

