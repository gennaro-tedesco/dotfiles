set runtimepath^=~/.vim 
set runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vim/vimrc

augroup HIGHLIGHT_YANK
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=700 }
augroup END
