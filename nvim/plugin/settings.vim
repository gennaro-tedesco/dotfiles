"" --------------
"" basic settings
"" --------------

" colour scheme
filetype plugin indent on
syntax enable
set termguicolors
set background=dark
colorscheme solarized8

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
set pastetoggle=<F3>
augroup PASTE
	autocmd!
	autocmd InsertLeave * silent! set nopaste
augroup END

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

" -----------------------------
" -- global augroup commands --
" -----------------------------
augroup SPECIAL_SYNTAX
	autocmd!
	autocmd BufNewFile,BufRead requirements*.txt set syntax=config
	autocmd BufNewFile,BufRead *.env set syntax=config
augroup END

augroup HIGHLIGHT_YANK
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=700 }
augroup END

augroup TERMINAL_OPEN
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

augroup LSP_HIGHLIGHTS
	autocmd!
	autocmd BufEnter * silent! hi clear DiagnosticWarn
	autocmd BufEnter * silent! hi link DiagnosticWarn Comment
	autocmd BufEnter * silent! hi clear CmpItemAbbrMatch
	autocmd BufEnter * silent! hi link CmpItemAbbrMatch helpVim
augroup END
