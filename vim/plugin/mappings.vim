"" ---------------------------------------
"" --- remapping and keys combinations ---
"" ---------------------------------------
" remap leader key
let mapleader = "\<Space>"
let maplocalleader =  "\<Space>"

" open help
nnoremap <F1> :h 

" remove all trailing spaces
nnoremap <F5> :call functions#TrimWhitespace()<CR>

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
onoremap H ^
nnoremap L $
onoremap L $
nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>
nnoremap <PageUp> {
nnoremap <PageDown> }
vnoremap <PageUp> {j
vnoremap <PageDown> }k

" tabs scroll between buffers
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" replace a word with yanked text
nnoremap rw viwpyiw

" copy entire line without newline character
nnoremap Y ^yg_

" copy text with line numbers and file name on top
vnoremap <leader>y :call functions#CompleteYank()<CR>

" paste into terminal mode 
tnoremap <leader>p <C-W>"+

" replace all occurrences of words under cursor
nnoremap S :%s///gc<Left><Left><Left>

" activate global substitute command
nnoremap gs :%s/
xnoremap gs :s/

" count all occurrences of word under cursor
nnoremap C :%s/<c-r>=expand("<cword>")<cr>//ng<CR>

" code navigation (with Coc)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

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
map <leader>v :e<space>~/.vim/vimrc<CR>
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


"" ----------------------------------
"" --- definition of new commands ---
"" ----------------------------------
command! -range ToTuple <line1>,<line2> call functions#ToTupleFun()
command! Jq :call functions#Jq()
command! TS silent! call functions#T2S()
command! ST silent! call functions#S2T()
command! Inst silent! call functions#Install()
command! Rf silent! call functions#ReplaceFile()

" instruct Rg not to include file names in the results
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

command! -bang Commits call fzf#vim#commits({'options': '--no-preview'}, <bang>0)

" shorthand commands for linting and fixing
command! Fix :ALEFix
command! Lint :ALEToggle

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

