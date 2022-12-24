----------------------------
----- initial settings -----
----------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

---------------------------------
--- plugins manager:lazy.nvim ---
---------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

--------------------
--- plugins list ---
--------------------
local plugins = {
	--- colorschemes, looks and syntax highlights
	{
		"lifepillar/vim-solarized8",
		config = function()
			vim.cmd([[colorscheme solarized8_flat]])
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dev = false,
		build = ":TSUpdate",
		event = "BufReadPost",

		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
		},
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				mappings = { "<C-u>", "<C-d>", "zt", "zz", "zb" },
			})
		end,
	},
	{
		"folke/noice.nvim",
		dependencies = {
			{ "MunifTanjim/nui.nvim" },
			{
				"rcarriga/nvim-notify",
				config = function()
					require("plugins.notify")
				end,
			},
		},
		config = function()
			require("plugins.noice")
		end,
	},
	--- LSP
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		config = function()
			require("plugins.lsp")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{
				"windwp/nvim-autopairs",
				config = function()
					require("plugins.autopairs")
				end,
			},
		},
		config = function()
			require("plugins.cmp")
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		config = true,
	},
}
require("lazy").setup(plugins)

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua", [[v:val =~ '\.lua$']])) do
	require(file:gsub("%.lua$", ""))
end
