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
nnoremap <F5> :call functions#TrimWhitespace()<CR>

" smarter indenting
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<
nnoremap <leader>= gg=Gg;

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
onoremap H ^
nnoremap L $
onoremap L $
nnoremap <PageUp> {
nnoremap <PageDown> }
vnoremap <PageUp> {j
vnoremap <PageDown> }k
nnoremap <S-Up> 5k
nnoremap <S-Down> 5j

" tabs scroll between buffers
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" close all splits/windows except the one in focus
nnoremap <leader>q <C-w>o

" copy in terminal mode (must be in normal mode in terminal)
tnoremap <leader>p <C-w>"+pa

" replace a word with yanked text
nnoremap rw viwpyiw

" toggle capitalisation
nnoremap <leader>w g~iw
vnoremap <leader>w ~

" copy entire line without newline character
nnoremap Y ^yg_

" copy text with line numbers and file name on top
vnoremap <leader>y :call functions#CompleteYank()<CR>

" replace all occurrences of words under cursor
nnoremap S :%s/<c-r><c-w>//gc<Left><Left><Left>

" blink word under cursor in search mode
nnoremap n n:call functions#BlinkWord(0.3)<CR>
nnoremap N N:call functions#BlinkWord(0.3)<CR>

" count all occurrences of word under cursor
nnoremap C :%s/<c-r>=expand("<cword>")<cr>//ng<CR>

" code navigation (with Coc) and linting
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> rn <Plug>(coc-rename)
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gm :<C-u>CocList outline<CR>
nnoremap <leader>f :ALEFix<CR>
nnoremap <leader>l :ALEToggle<CR>

" buffers and files browsing
nnoremap <C-n> :FloatermNew vifm<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-h> :Grepper<CR>
nnoremap <silent> <C-q> :w <Bar> bd<CR>
nnoremap q/ :call fzf#vim#search_history({'right': '40'})<CR>
nnoremap q: :call fzf#vim#command_history({'right': '40'})<CR>
nnoremap qh :call fzf#vim#helptags({'down': '15'})<CR>

" git remappings
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :GBranches<CR>
nnoremap <leader>gp :Git push <Bar> copen<CR>
nnoremap <leader>gl :BCommit<CR>

" open todo file in one go
nnoremap <leader>t :e<space>~/.todo<CR>

" navigate through the completion menu
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" wilder completion menu
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

" clean up search results
nnoremap <silent> <CR> :let @/=""<CR>

"" ----------------------------------
"" --- definition of new commands ---
"" ----------------------------------
command! -range ToTuple <line1>,<line2> call functions#ToTupleFun()
command! Jq silent! call functions#Jq()
command! TS silent! call functions#T2S()
command! ST silent! call functions#S2T()
command! Inst silent! call functions#Install()
command! Rf silent! call functions#ReplaceFile()

" CoC show documentation
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	elseif (coc#rpc#ready())
		call CocActionAsync('doHover')
	else
		execute '!' . &keywordprg . " " . expand('<cword>')
	endif
endfunction

