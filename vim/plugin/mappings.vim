"" ---------------------------------------
"" --- remapping and keys combinations ---
"" ---------------------------------------
" remap leader key
let mapleader = "\<Space>"
let maplocalleader =  "\<Space>"

" open help
nnoremap <F1> :h 

" remove all trailing spaces
nnoremap <F5> :call TrimWhitespace()<CR>

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
nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>

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

" paste into terminal mode 
tnoremap <leader>p <C-W>"+

" replace all occurrences of words under cursor
nnoremap S :%s///gc<Left><Left><Left>

" count all occurrences of word under cursor
nnoremap C :%s/<c-r>=expand("<cword>")<cr>//ng<CR>

" buffers and files browsing
nnoremap <C-n> :FloatermNew vifm<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-o> :History<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :BLines<CR>
nnoremap <C-h> :Rg<CR>
nnoremap <silent> <C-q> :bd<CR>

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

" wilder completion menu
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

" clean up search results
nnoremap <silent> <CR> :let @/=""<CR>

" navigation controls when in diff mode
if &diff
	nnoremap <expr> <Right> '<C-W>l'
	nnoremap <expr> <Left> '<C-W>h'
	nnoremap <expr> <Down> ']c'
	nnoremap <expr> <Up> '[c'
	nnoremap q :qa<CR>
endif

