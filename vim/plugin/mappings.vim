"" ---------------------------------------
"" --- remapping and keys combinations ---
"" ---------------------------------------

" remapping open file in new tab 
cabbrev tn tabnew

" better indenting
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<

" code folding
nnoremap + zR
nnoremap - zM


" remapping the escape key 
inoremap jj <ESC> :w<CR>
inoremap kk <ESC> :w<CR>

" easier navigation
nnoremap W 5w
nnoremap B 5b
nnoremap H ^
nnoremap L $

" scroll tabs 
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabpre<CR>

" Use <alt+hjkl> to resize panes
nnoremap <silent> ∆ :resize +2<CR>
nnoremap <silent> º :resize -2<CR>
nnoremap <silent> ª :vertical resize +2<CR>
nnoremap <silent> @ :vertical resize -2<CR>

" remap leader key
let mapleader = "\<Space>"
let maplocalleader =  "\<Space>"

" replace a word with yanked text 
nnoremap rw viwpyiw

" copy entire line without newline character
nnoremap Y ^yg_

" replace all occurrences of words under cursor 
nnoremap S :%s///gc<Left><Left><Left>

" mapping of navigation commands
nnoremap <leader><leader> :Ranger<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-o> :History<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <leader>f :BLines<CR>
nnoremap <leader>F :Rg<CR>

" git fugitive remapping
nnoremap <leader>gs :vertical Gstatus<CR>
nnoremap <leader>gc :GCheckout<CR>
nnoremap <leader>gp :Gpush <Bar> copen<CR>
nnoremap <leader>gl :Commit<CR>

" open up vimconfig and zshconfig in one go
map <leader>v :tabnew<space>~/.vimrc<CR>
map <leader>z :tabnew<space>~/.zshrc<CR>
map <leader>t :tabnew<space>~/.todo<CR>

" navigate through the completion menu
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"

" clean up search results
nnoremap <silent> <CR> :let @/=""<CR>

" navigation controls when in diff mode
if &diff
    nnoremap <leader>d3 :diffget //3<CR>
    nnoremap <leader>d2 :diffget //2<CR>
    nnoremap <expr> <Right> '<C-W>l'
    nnoremap <expr> <Left> '<C-W>h'
    nnoremap <expr> <Down> ']c'
    nnoremap <expr> <Up> '[c'
    nnoremap q :qa<CR>
endif

