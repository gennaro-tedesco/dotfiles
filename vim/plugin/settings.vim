"" --------------
"" basic settings
"" --------------

" colour scheme
filetype plugin indent on
syntax enable
set termguicolors
set background=dark
colorscheme solarized8

" cursorline and windows frame
set number relativenumber
set wrap
set ruler
set cursorline
set laststatus=2
set splitbelow splitright
set scrolloff=8

" standard vim behaviour
augroup Format
	autocmd!
	autocmd FileType * set formatoptions-=cro
augroup END

set noswapfile
set nocompatible
set hidden
set mouse=a
set updatetime=100
set showcmd
set sidescroll=1
set clipboard+=unnamed
set autoindent noexpandtab tabstop=4 shiftwidth=4
set list listchars=tab:\ \ ,trail:·,nbsp:⎵

" search options
set hlsearch
set showmatch

" autocompletion options
set shortmess+=c
set completeopt="menuone,preview"
set wildmenu
set wildmode=longest,full,list
set wildcharm=<Tab>
