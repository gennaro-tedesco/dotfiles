" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'dense-analysis/ale'
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
set scrolloff=8

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

"" -----------------------------
"" --- automatically loading ---
"" -----------------------------
"" ~/.vim/plugin/mappings.vim
"" ~/.vim/plugin/options.vim
"" -----------------------------

"" ----------------------------
"" --- additional functions ---
"" ----------------------------

" set autocompletion
function! TabComplete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction
inoremap <Tab> <C-R>=TabComplete()<CR>

" navigation controls when in diff mode
if &diff
    nnoremap <leader>d3 :diffget //3<CR>
    nnoremap <leader>d2 :diffget //2<CR>
    nnoremap <expr> <Right> '<C-W>l'
    nnoremap <expr> <Left> '<C-W>h'
    nnoremap <expr> <Down> ']c'
    nnoremap <expr> <Up> '[c'
    cabbrev q qa 
endif

