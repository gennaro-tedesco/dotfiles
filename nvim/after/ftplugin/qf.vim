function! s:adjust_height(minheight, maxheight)
  exe max([min([line("$")+1, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

call s:adjust_height(3, 10)

setlocal cursorline
setlocal nonumber norelativenumber
hi Search cterm=None ctermfg=None ctermbg=None gui=None guifg=None

nnoremap qq :q<CR>
