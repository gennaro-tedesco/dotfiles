"" ---------------------------------------
"" --- remapping and keys combinations ---
"" ---------------------------------------
" remap leader key
let mapleader = "\<Space>"
let maplocalleader =  "\<Space>"

" prevent record functionality
nnoremap q <nop>
nnoremap qq q

" remove all trailing spaces
nnoremap <F5> :lua require("functions").trim_whitespace()<CR>

" smarter indenting
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<
nnoremap <leader>= gqap;

" remapping the escape key
inoremap jj <ESC>
vnoremap jj <ESC>
inoremap kk <ESC>
vnoremap kk <ESC>

" treat visual lineas as actual lines
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" easier navigation
nnoremap E 5e
nnoremap B 5b
nnoremap H ^
onoremap H ^
nnoremap L $
onoremap L $
nnoremap <PageUp> k{j
nnoremap <PageDown> j}k
vnoremap <PageUp> k{j
vnoremap <PageDown> j}k
nnoremap <Tab> <C-w>w
nnoremap <S-Tab> <C-w>W
nnoremap u m`u``

" close all splits/windows except the one in focus
nnoremap <leader>q <C-w>o

" avoid x and s to override the clipboard
nnoremap x "_x
nnoremap s "_s
nnoremap X "_X

" replace a word with yanked text
nnoremap rw viwpyiw

" replace till the end of line with yanked text
nnoremap rl Pl"_D

" toggle capitalisation
nnoremap <leader>w g~iw
vnoremap <leader>w ~

" copy file name to the clipboard
nnoremap yf :let @+=expand("%")<CR>

" copy text with line numbers and file name on top
vnoremap <leader>y :call functions#CompleteYank()<CR>

" count all occurrences of word under cursor
nnoremap * *:lua require("functions").count_matches()<CR>

" blink word under cursor in search mode
nnoremap n nzz:lua require("functions").hl_search(0.3)<CR>
nnoremap N Nzz:lua require("functions").hl_search(0.3)<CR>

" buffers and files browsing
nnoremap <C-n> :FloatermNew vifm<CR>
nnoremap <C-p> :<cmd>lua require('fzf-lua').files()<CR>
nnoremap <C-b> :<cmd>lua require('fzf-lua').buffers()<CR>
nnoremap <C-h> :Rg 
nnoremap <C-g> :lua require("functions").replace_grep()<CR>
nnoremap <F1> :<cmd> lua require('fzf-lua').help_tags()<CR>
nnoremap <silent> <C-q> :lua require("functions").toggle_qf()<CR>
nnoremap <silent> <C-l> :lua require("functions").toggle_ll()<CR>
nnoremap gm :SymbolsOutline<CR>

" git remappings
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :BCommits<CR>

" open todo file in one go
nnoremap <leader>t :e<space>~/.todo<CR>

" clean up search results and extmarks
nnoremap <silent> <CR> :let @/="" <bar> lua vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)<CR>

" delete all marks
nnoremap mx :delm! <bar> delm A-Z0-9 <bar> delm \"<> <bar> wshada!<CR>

"" ----------------------------------
"" --- definition of new commands ---
"" ----------------------------------
command! -range ToTuple <line1>,<line2> call functions#ToTupleFun()
command! TS silent! call functions#T2S()
command! ST silent! call functions#S2T()
command! Rf silent! lua require("functions").replace_file()<CR>
command W write
command Q quit
command! -bar -bang -range=% BCommits let b:fzf_winview = winsaveview() | <line1>,<line2>call fzf#vim#buffer_commits(fzf#vim#with_preview({'options': '--prompt "logs:"', 'down': '15'}), <bang>0)
