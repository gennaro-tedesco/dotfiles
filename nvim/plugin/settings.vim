"" --------------
"" basic settings
"" --------------

" colour scheme
set termguicolors
set background=dark
colorscheme solarized8_flat

" cursorline, windows frame and looks
set showbreak=↪\
set list listchars=tab:\ \ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set fillchars=eob:\ 
set number relativenumber
set ruler
set cursorline
set laststatus=3
set cmdheight=0
set splitbelow splitright
set scrolloff=8
set noshowmode
highlight WinSeparator guibg=None

" standard vim behaviour
augroup FORMAT
	autocmd!
	autocmd FileType * set formatoptions-=cro
augroup END

set noswapfile
set hidden
set mouse=a
set updatetime=100
set showcmd
set sidescroll=1
set clipboard+=unnamed
set autoindent noexpandtab tabstop=4 shiftwidth=4

" diff options
set diffopt+=context:3,linematch:60

" search options
set inccommand=split
set ignorecase
set smartcase
set hlsearch
set showmatch

" autocompletion options
set shortmess+=c
set completeopt=menu,menuone,noselect
set wildmenu
set wildmode=longest,full,list
set wildcharm=<Tab>
set pumheight=10

" matching pairs
set matchpairs+=<:>

" python host program
let g:python3_host_prog = "/usr/local/bin/python3"

" -----------------------------
" -- global augroup commands --
" -----------------------------
augroup HIGHLIGHT_YANK
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=700 }
augroup END

augroup TERMINAL_OPEN
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

augroup HIGHLIGHTS
	autocmd!
	autocmd BufEnter * silent! hi clear ErrorMsg
	autocmd BufEnter * silent! hi ErrorMsg cterm=bold gui=bold guifg=#dc322f guibg=None
	autocmd BufEnter * silent! hi clear DiffDelete
	autocmd BufEnter * silent! hi DiffDelete cterm=bold ctermfg=12 ctermbg=6 gui=bold guifg=#dc322f guibg=None
	autocmd BufEnter * silent! hi clear DiffChange
	autocmd BufEnter * silent! hi DiffChange ctermbg=5 guifg=#b58900 guibg=None guisp=#b58900
augroup END

augroup LASTPLACE
	autocmd!
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
