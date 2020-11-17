"" ---------------------------------------
"" --- remapping and keys combinations ---
"" ---------------------------------------

" remapping the help text
cabbrev h vert h

" remapping open file in new tab 
cabbrev tn tabnew

" better indenting
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<

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
nnoremap -- :Ranger<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-o> :History<CR>
nnoremap <leader>b :Buffers<CR>
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

" select the complete menu item like CTRL+y would.
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"

" cancel the complete menu item like CTRL+e would.
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"

" clean up search results
nnoremap <silent> <CR> :let @/=""<CR>


