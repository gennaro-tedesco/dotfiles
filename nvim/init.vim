"" ----------------------------
"" --- plugins declarations ---
"" ----------------------------

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" code autocompletion, language servers and the like
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'lervag/vimtex'

" git integration in vim
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
Plug 'mhinz/vim-signify'
Plug 'akinsho/git-conflict.nvim'

" file navigation
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'

" vim decorations and looks
Plug 'mhinz/vim-startify'
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'karb94/neoscroll.nvim'
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf.git'
Plug 'kevinhwang91/nvim-bqf'

" settings that make vim easier to use
Plug 'chentoast/marks.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'rcarriga/nvim-notify'
Plug 'ethanholz/nvim-lastplace'

" my personal plugins: they are awesome
Plug 'gennaro-tedesco/nvim-commaround'
Plug 'gennaro-tedesco/nvim-peekup'
Plug 'gennaro-tedesco/nvim-jqx'
Plug 'gennaro-tedesco/nvim-dvc'

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
lua require("options")
lua require("globals")
lua require("lsp_config")
lua require("cmp_config")

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
