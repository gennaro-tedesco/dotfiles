" -----------------------------
" -- global augroup commands --
" -----------------------------
augroup HIGHLIGHT_YANK
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=700 }
augroup END

augroup TERMINAL_OPEN
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

augroup HIGHLIGHTS
	autocmd!
	autocmd BufEnter * silent! hi clear DiffDelete
	autocmd BufEnter * silent! hi DiffDelete cterm=bold ctermfg=12 ctermbg=6 gui=bold guifg=#dc322f guibg=None
	autocmd BufEnter * silent! hi clear DiffChange
	autocmd BufEnter * silent! hi DiffChange ctermbg=5 guifg=#b58900 guibg=None guisp=#b58900
augroup END

augroup LASTPLACE
	autocmd!
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
