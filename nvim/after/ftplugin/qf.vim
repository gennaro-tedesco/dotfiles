setlocal cursorline
hi Search cterm=None ctermfg=None ctermbg=None gui=None guifg=None

nnoremap qq :q<CR>
nnoremap <buffer> <CR> :lua require('bqf.jump').open(true)<CR>

