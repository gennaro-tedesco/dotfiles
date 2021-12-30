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

" remapping the escape key
inoremap jj <ESC>
vnoremap jj <ESC>
inoremap kk <ESC>
vnoremap kk <ESC>

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

" close all splits/windows except the one in focus
nnoremap <leader>q <C-w>o

" paste in terminal mode (must be in normal mode in terminal)
tnoremap pp <C-w>"+pa

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

" replace all occurrences of word under cursor in current file
nnoremap S :%s/<c-r><c-w>//gc<Left><Left><Left>

" replace all occurrences of word under cursor projectwise
nnoremap R
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" count all occurrences of word under cursor
nnoremap * *:%s/<c-r>=expand("<cword>")<cr>//ng<CR>

" blink word under cursor in search mode
nnoremap n nzz:call functions#BlinkWord(0.3)<CR>
nnoremap N Nzz:call functions#BlinkWord(0.3)<CR>

" insert hyperlink markdown at current word
inoremap lll <Esc>bi[<Esc>A]()<Left>

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
nnoremap <C-p> :call fzf#vim#files(system('git rev-parse --show-toplevel 2> /dev/null')[:-2], {'options': '--prompt "files:"'})<CR>
nnoremap <C-b> :call fzf#vim#buffers({'options': '--prompt "buffers:"'})<CR>
nnoremap <C-h> :Grepper<CR>
nnoremap q/ :call fzf#vim#search_history({'options': '--prompt "search:"', 'right': '40'})<CR>
nnoremap q: :call fzf#vim#command_history({'options': '--prompt "cmd:"', 'right': '40'})<CR>
nnoremap qh :call fzf#vim#helptags({'options': '--prompt "help:"','down': '15'})<CR>
nnoremap <silent> <C-q> :call functions#ToggleQF()<CR>
nnoremap <silent> <C-l> :call functions#ToggleLL()<CR>

" git remappings
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :GBranches<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :BCommits<CR>
nnoremap <expr> <Down> &diff ? ']c' : '<Down>'
nnoremap <expr> <Up> &diff ? '[c' : '<Up>'

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
command! TS silent! call functions#T2S()
command! ST silent! call functions#S2T()
command! Rf silent! call functions#ReplaceFile()
command! EmptyRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
command W write
command GetL :diffget //2
command GetR :diffget //3

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

