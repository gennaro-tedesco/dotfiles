"" ---------------------------------------
"" --- remapping and keys combinations ---
"" ---------------------------------------
" remap leader key
let mapleader = "\<Space>"
let maplocalleader =  "\<Space>"

" smarter indenting
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<

" code folding
nnoremap + zR
nnoremap - zM

" remapping the escape key 
inoremap jj <ESC>
inoremap kk <ESC>

" easier navigation
nnoremap W 5w
nnoremap B 5b
nnoremap H ^
nnoremap L $

" tabs scroll between buffers
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" Use <alt+hjkl> to resize panes
nnoremap <silent> ∆ :resize +2<CR>
nnoremap <silent> º :resize -2<CR>
nnoremap <silent> ª :vertical resize +2<CR>
nnoremap <silent> @ :vertical resize -2<CR>

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
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :BLines<CR>
nnoremap <leader>F :Rg<CR>

" git fugitive remapping
nnoremap <leader>gs :vertical Gstatus<CR>
nnoremap <leader>gc :GCheckout<CR>
nnoremap <leader>gp :Gpush <Bar> copen<CR>
nnoremap <leader>gl :Commit<CR>

" open up vimconfig and zshconfig in one go
map <leader>v :e<space>~/.vimrc<CR>
map <leader>z :e<space>~/.zshrc<CR>
map <leader>t :e<space>~/.todo<CR>

" navigate through the completion menu
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

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

