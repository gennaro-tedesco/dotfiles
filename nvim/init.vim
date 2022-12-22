set termguicolors
"" ----------------------------
"" --- plugins declarations ---
"" ----------------------------

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" LSP code autocompletion, language servers and the like
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'smjonas/inc-rename.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'lervag/vimtex'

" git integration in vim
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'akinsho/git-conflict.nvim'

" file navigation
Plug 'numToStr/FTerm.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'jremmen/vim-ripgrep'

" vim decorations and looks
Plug 'goolord/alpha-nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lifepillar/vim-solarized8'
Plug 'karb94/neoscroll.nvim'
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf.git'
Plug 'kevinhwang91/nvim-bqf'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'

" settings that make vim easier to use
Plug 'chentoast/marks.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'kylechui/nvim-surround'
Plug 'rcarriga/nvim-notify'
Plug 'numToStr/Comment.nvim'

" my personal plugins: they are awesome
Plug 'gennaro-tedesco/nvim-jqx'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

lua << EOF
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua', [[v:val =~ '\.lua$']])) do
  require(file:gsub('%.lua$', ''))
end

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua/plugins', [[v:val =~ '\.lua$']])) do
  require("plugins."..file:gsub('%.lua$', ''))
end

EOF
