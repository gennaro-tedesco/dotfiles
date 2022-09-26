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
nnoremap <BS> <C-o>
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
nnoremap n nzz:call functions#BlinkWord(0.3)<CR>
nnoremap N Nzz:call functions#BlinkWord(0.3)<CR>

" code navigation (with Coc) and linting
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> rn <Plug>(coc-rename)
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent> gm :<C-u>CocList outline<CR>
nnoremap <leader>f :ALEFix<CR>
nnoremap <leader>l :ALEToggle<CR>
nmap <silent> <leader>+ <Plug>(ale_next_wrap)
nmap <silent> <leader>- <Plug>(ale_previous_wrap)

" buffers and files browsing
nnoremap <C-n> :FloatermNew vifm<CR>
nnoremap <C-p> :call fzf#vim#files(system('git rev-parse --show-toplevel 2> /dev/null')[:-2], {'options': '--prompt "files:"'})<CR>
nnoremap <C-b> :call fzf#vim#buffers({'options': '--prompt "buffers:"'})<CR>
nnoremap <C-h> :Rg 
nnoremap <C-g> :lua require("functions").replace_grep()<CR>
nnoremap q/ :call fzf#vim#search_history({'options': '--prompt "search:"', 'right': '40'})<CR>
nnoremap q: :call fzf#vim#command_history({'options': '--prompt "cmd:"', 'right': '40'})<CR>
nnoremap qh :call fzf#vim#helptags({'options': '--prompt "help:"','down': '15'})<CR>
nnoremap <silent> <C-q> :call functions#ToggleQF()<CR>
nnoremap <silent> <C-l> :call functions#ToggleLL()<CR>

" git remappings
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :BCommits<CR>
nnoremap <leader>gb <Plug>(git-messenger)
nnoremap <leader>gd :Gvdiffsplit develop<CR>
nmap ++ <plug>(signify-next-hunk)
nmap -- <plug>(signify-prev-hunk)

" open todo file in one go
nnoremap <leader>t :e<space>~/.todo<CR>

" navigate through the completion menu
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1):
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"
inoremap <nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" wilder completion menu
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

" clean up search results
nnoremap <silent> <CR> :let @/=""<CR>

" delete all marks
nnoremap mx :delm! <bar> delm A-Z0-9 <bar> delm \"<> <bar> wshada!<CR>

"" ----------------------------------
"" --- definition of new commands ---
"" ----------------------------------
command! -range ToTuple <line1>,<line2> call functions#ToTupleFun()
command! TS silent! call functions#T2S()
command! ST silent! call functions#S2T()
command! Rf silent! call functions#ReplaceFile()
command W write
command! -bar -bang -range=% BCommits let b:fzf_winview = winsaveview() | <line1>,<line2>call fzf#vim#buffer_commits(fzf#vim#with_preview({'options': '--prompt "logs:"', 'down': '15'}), <bang>0)
command! Error :lua require("functions").copy_error()<CR>

" CoC functions
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A
