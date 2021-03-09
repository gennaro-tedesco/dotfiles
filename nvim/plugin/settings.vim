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
set showbreak=↪\
set list listchars=tab:\ \ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set number relativenumber
set ruler
set cursorline
set laststatus=2
set splitbelow splitright
set scrolloff=8

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

" search options
set inccommand=split
set ignorecase
set smartcase
set hlsearch
set showmatch

" autocompletion options
set shortmess+=c
set completeopt="menuone,preview"
set wildmenu
set wildmode=longest,full,list
set wildcharm=<Tab>

" matching pairs
set matchpairs+=<:>

" special syntax for certain files
augroup SPECIAL_SYNTAX
	autocmd!
	autocmd BufNewFile,BufRead requirements*.txt set syntax=config
	autocmd BufNewFile,BufRead *.env set syntax=config
augroup END
