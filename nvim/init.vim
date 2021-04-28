"" ----------------------------
"" --- plugins declarations ---
"" ----------------------------

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" code autocompletion, language servers and the like
Plug 'dense-analysis/ale'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lervag/vimtex'

" git integration in vim
Plug 'tpope/vim-fugitive'
Plug 'stsewd/fzf-checkout.vim'
Plug 'mhinz/vim-signify'

" file navigation
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kevinhwang91/nvim-bqf'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

" vim decorations and looks
Plug 'mhinz/vim-startify'
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'karb94/neoscroll.nvim'

" settings that make vim easier to use
Plug 'MattesGroeger/vim-bookmarks'
Plug 'ervandew/supertab'

" my personal plugins: they are awesome
Plug 'gennaro-tedesco/nvim-commaround'
Plug 'gennaro-tedesco/nvim-peekup'
Plug 'gennaro-tedesco/nvim-jqx'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"" ----------------------------------
"" ----- automatically loading ------
"" ----------------------------------
"" ~/.config/nvim/plugin/settings.vim
"" ~/.config/nvim/plugin/mappings.vim
"" ~/.config/nvim/plugin/options.vim
"" ~/.config/nvim/plugin/folding.vim
"" -----------------------------------

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

lua <<EOF
require'nvim-treesitter.configs'.setup {
	highlight = {enable = true},
	ensure_installed = {"go", "python", "json", "lua", "bash", "yaml"}
}

require('neoscroll').setup()
EOF

