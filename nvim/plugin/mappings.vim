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
nnoremap <F5> <cmd> lua require("functions").trim_whitespace()<CR>

" smarter indenting
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<

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
nnoremap vv ^vg_

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
nnoremap yf <cmd> let @+=expand("%") <bar> echo "copied: ".@% <CR>

" count all occurrences of word under cursor
nnoremap * *<cmd>lua require("functions").count_matches()<CR>

" blink word under cursor in search mode
nnoremap n nzz<cmd>lua require("functions").hl_search(0.3)<CR>
nnoremap N Nzz<cmd>lua require("functions").hl_search(0.3)<CR>

" buffers and files browsing
nnoremap <C-n> <cmd> FloatermNew vifm<CR>
nnoremap <C-p> <cmd> lua require('fzf-lua').files({show_cwd_header=false, cwd=require("functions").git_root()})<CR>
nnoremap <C-b> <cmd> lua require('fzf-lua').buffers()<CR>
nnoremap <C-h> :Rg<space>
nnoremap <C-g> <cmd> lua require("functions").replace_grep()<CR>
nnoremap <F1>  <cmd> lua require('fzf-lua').help_tags()<CR>
nnoremap <C-q> <cmd> lua require("functions").toggle_qf()<CR>
nnoremap <C-l> <cmd> lua require("functions").toggle_ll()<CR>
nnoremap gm <cmd> SymbolsOutline<CR>
nnoremap "" <cmd> lua require('fzf-lua').registers()<CR>
nnoremap <leader>sn <cmd> lua require('plugins.sessions').new()<CR>
nnoremap <leader>su <cmd> lua require('plugins.sessions').update()<CR>
nnoremap <leader>sl <cmd> lua require('plugins.sessions').list()<CR>

" git remappings
nnoremap <leader>gs <cmd> Git<CR>
nnoremap <leader>gp <cmd> Git push<CR>
nnoremap <leader>gl <cmd> lua require('fzf-lua').git_bcommits()<CR>
nnoremap <leader>gb <cmd> lua require('fzf-lua').git_branches()<CR>

" open todo file in one go
nnoremap <leader>t <cmd>e ~/.todo<CR>

" clean up search results and extmarks
nnoremap <silent> <CR> :let @/="" <bar> lua vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)<CR>

" delete all marks
nnoremap mx <cmd> delm! <bar> delm A-Z0-9 <bar> delm \"<> <bar> wshada!<CR>

"" ----------------------------------
"" --- definition of new commands ---
"" ----------------------------------
command! Rf silent! lua require("functions").replace_file()<CR>
command W write
command Q quit
