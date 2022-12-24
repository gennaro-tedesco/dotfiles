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
		init = function()
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
	--- LSP and code autocompletion
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
	--- file navigation
	{
		"ibhagwan/fzf-lua",
		branch = "main",
		init = function()
			local fzf = require("fzf-lua")
			vim.keymap.set({ "n" }, "<C-p>", function()
				fzf.files({ show_cwd_header = false, cwd = require("functions").git_root() })
			end)

			vim.keymap.set({ "n" }, "<C-b>", function()
				fzf.buffers()
			end)
			vim.keymap.set({ "n" }, "<F1>", function()
				fzf.help_tags()
			end)
			vim.keymap.set({ "n" }, '""', function()
				fzf.registers()
			end)
			vim.keymap.set({ "n" }, "<leader>gb", function()
				fzf.git_branches()
			end)
			vim.keymap.set({ "n" }, "<leader>gc", function()
				fzf.git_bcommits()
			end)
		end,
		config = function()
			require("plugins.fzf")
		end,
	},
	{
		"numToStr/FTerm.nvim",
		init = function()
			vim.keymap.set("n", "<F2>", '<CMD>lua require("FTerm").toggle()<CR>')
			vim.keymap.set("t", "<F2>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
		end,
		config = { border = "rounded", dimensions = { height = 0.85, width = 0.9 } },
		keys = { "<F2>" },
	},
	{
		"nvim-tree/nvim-tree.lua",
		init = function()
			vim.keymap.set("n", "<C-n>", function()
				require("nvim-tree.api").tree.toggle()
			end)
		end,
		config = function()
			require("plugins.nvim_tree")
		end,
		keys = { "<C-n>" },
	},
	{
		"jremmen/vim-ripgrep",
		init = function()
			vim.keymap.set("n", "<C-h>", ":Rg<space>")
		end,
	},
}

local opts = {
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "📌",
		},
	},
	checker = {
		enabled = true,
	},
}
require("lazy").setup(plugins, opts)

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua", [[v:val =~ '\.lua$']])) do
	require(file:gsub("%.lua$", ""))
end
