" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'thaerkh/vim-indentguides'
Plug 'tpope/vim-sensible'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'stsewd/fzf-checkout.vim'
Plug 'mechatroner/rainbow_csv'
Plug 'yuttie/comfortable-motion.vim'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'frazrepo/vim-rainbow'
Plug 'airblade/vim-gitgutter'
Plug 'francoiscabrol/ranger.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/calendar.vim'
Plug 'wincent/terminus'
Plug 'vim-scripts/AutoComplPop'
Plug 'haya14busa/is.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'lifepillar/vim-solarized8'
Plug 'lervag/vimtex'
Plug 'davidhalter/jedi-vim', { 'for':  'python' }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" customisation of default plugin options 
let g:indentguides_tabchar = '.'
let g:indentguides_ignorelist = ['help']
let g:rainbow_active = 1
let g:gitgutter_enabled = 1
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.8 } }
let g:calendar_first_day = 'monday'
let g:lightline = {
			\ 'active': {
			\	'left': [ [ 'mode', 'paste' ],
			\				[ 'gitbranch','readonly', 'filename', 'modified'] ]
			\ },
			\ 'component_function': {
			\	'gitbranch': 'FugitiveHead'
			\ },
			\ }
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'
let g:tex_flavor = 'latex'
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#goto_command = "gd"
let g:jedi#usages_command = "gu"
let g:jedi#show_call_signatures = 0
let g:startify_custom_header = startify#center(['welcome back, and a fine day it is!'])
let g:startify_files_number = 15
let g:startify_lists = [
			\ { 'type': 'dir',	   'header': ['   Current Directory '. getcwd()] },
			\ { 'type': 'files',	   'header': ['   Files']			 },
			\ ]
let g:ranger_map_keys = 0
let g:fzf_checkout_merge_settings = v:false
let g:fzf_branch_actions = {
			\ 'checkout': {
			\	'prompt': 'Checkout> ',
			\	'execute': 'echo system("{git} checkout {branch}")',
			\	'multiple': v:false,
			\	'keymap': 'enter',
			\	'required': ['branch'],
			\	'confirm': v:false,
			\ },
			\ 'track': {
			\	'prompt': 'Track> ',
			\	'execute': 'echo system("{git} checkout --track {branch}")',
			\	'multiple': v:false,
			\	'keymap': 'alt-enter',
			\	'required': ['branch'],
			\	'confirm': v:false,
			\ },
			\ 'diff': {
			\	'prompt': 'Diff> ',
			\	'execute': 'Git diff {branch}',
			\	'multiple': v:false,
			\	'keymap': 'ctrl-f',
			\	'required': ['branch'],
			\	'confirm': v:false,
			\ },
			\ 'delete': {
			\   'prompt': 'Delete> ',
			\   'execute': 'echo system("{git} branch -D {branch}")',
			\   'multiple': v:true,
			\   'keymap': 'ctrl-d',
			\   'required': ['branch'],
			\   'confirm': v:true,
			\ },
			\}

" basic settings for colour and themes
filetype plugin indent on
syntax enable
set termguicolors
set background=dark
colorscheme solarized8

" cursorline and windows frame
set number relativenumber
set wrap
autocmd FileType * set formatoptions-=cro
set ruler
set cursorline
set laststatus=2
set splitbelow splitright

" standard vim behaviour
set noswapfile
set nocompatible
set hidden
set mouse=a
set updatetime=100
set showcmd
set sidescroll=1
set clipboard+=unnamed
set autoindent noexpandtab tabstop=4 shiftwidth=4

" search options
set wildmenu
set hlsearch
set showmatch

" autocompletion options
set shortmess+=c
set completeopt="menuone,preview"
set wildmode=longest,full,list

"" ---------------------------------------
"" --- remapping and keys combinations ---
"" ---------------------------------------

" remapping the help text
cabbrev h tab h

" remapping open file in new tab 
cabbrev tn tabnew

" remapping the escape key 
inoremap jj <ESC>
inoremap kk <ESC>

" easier navigation
nnoremap W 5w
nnoremap B 5b

" remap leader key
let mapleader = "\<Space>"
let maplocalleader =  "\<Space>"

" replace a word with yanked text 
nnoremap rw viwpyiw

" replace all occurrences of words under cursor 
nnoremap S :%s///gc<Left><Left><Left>

" mapping of navigation commands
nnoremap <leader><leader> :RangerNewTab<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-o> :History<CR>
nnoremap <leader>f :Rg<CR>

" git fugitive remapping
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :GCheckout<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>

" open up vimconfig and zshconfig in one go
map <leader>v :tabnew<space>~/.vimrc<CR>
map <leader>z :tabnew<space>~/.zshrc<CR>
map <leader>t :tabnew<space>~/.todo<CR>

" select the complete menu item like CTRL+y would.
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"

" cancel the complete menu item like CTRL+e would.
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"

"" ----------------------------
"" --- additional functions ---
"" ----------------------------

" set autocompletion
function! Tab_Or_Complete()
	if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
		return "\<C-N>"
	else
		return "\<Tab>"
	endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" prettify json
function Jq ()
	if (&ft=='json' || &ft=='')
		:%! jq .
	else
		echo "not a json file"
	endif
endfunction
cabbrev jq call Jq()
autocmd BufReadPost *.json silent! :call Jq()

" T2S and S2T
function T2S ()
	set expandtab | %retab! | w
endfunction
cabbrev t2s silent! call T2S()

function S2T ()
	set noexpandtab | %retab! | w
endfunction
cabbrev s2t silent! call S2T()

" installation of plugins 
function Install()
	:w | so% | PlugInstall | PlugUpdate
endfunction
cabbrev inst silent! call Install()

function ReplaceFile()
	:norm gg"_dGP
endfunction
cabbrev rf silent! call ReplaceFile()

"" --------------------
"" --- autocommands ---
"" --------------------

" convert t2s when saving python files 
autocmd BufWritePre *.py silent! call T2S() 

" navigation controls when in diff mode
if &diff
	nnoremap <expr> <Right> '<C-W>l'
	nnoremap <expr> <Left> '<C-W>h'
	nnoremap <expr> <Down> ']c'
	nnoremap <expr> <Up> '[c'
endif

