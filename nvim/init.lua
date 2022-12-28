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
local config_path = vim.fn.stdpath("config")
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

local ok, lazy = pcall(require, "lazy")
if not ok then
	print("lazy not installed")
	return
end
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
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.lualine")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dev = false,
		build = ":TSUpdate",
		event = "BufReadPost",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				event = "BufReadPre",
				config = true,
			},
		},
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"karb94/neoscroll.nvim",
		keys = { "<C-u>", "<C-d>", "zt", "zz", "zb" },
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
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			require("plugins.alpha")
		end,
	},
	{ "kevinhwang91/nvim-bqf", config = { func_map = { openc = "<CR>" } } },

	--- LSP, language servers and code autocompletion
	{ "nvim-lua/plenary.nvim" },
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"smjonas/inc-rename.nvim",
			event = "InsertEnter",
			config = true,
		},
		config = function()
			require("plugins.lsp")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
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
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		config = function()
			require("plugins.snip")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufEnter",
		config = function()
			require("plugins.null_ls")
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		init = function()
			vim.keymap.set("n", "gm", "<cmd>SymbolsOutline<CR>")
		end,
		config = function()
			require("plugins.symbols_outline")
		end,
	},
	{
		"lervag/vimtex",
		init = function()
			vim.g.vimtex_view_general_viewer = "zathura"
			vim.g.vimtex_view_zathura_options = "-reuse-instance"
			vim.g.vimtex_imaps_leader = ","
			vim.g.tex_conceal = ""
			vim.g.tex_fast = ""
			vim.g.tex_flavor = "latex"
		end,
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
		config = function()
			require("plugins.fterm")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		init = function()
			vim.keymap.set("n", "<C-n>", function()
				require("nvim-tree.api").tree.toggle()
			end)
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.nvim_tree")
		end,
	},
	{
		"jremmen/vim-ripgrep",
		cmd = "Rg",
		init = function()
			vim.keymap.set("n", "<C-h>", ":Rg<space>")
			vim.keymap.set("n", "<C-g>", "<cmd> lua require('functions').replace_grep()<CR>")
		end,
	},

	--- git integration
	{
		"tpope/vim-fugitive",
		init = function()
			vim.keymap.set("n", "<leader>gs", "<cmd> Git<CR>")
			vim.keymap.set("n", "<leader>gp", "<cmd> Git push<CR>")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("plugins.gitsigns")
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		init = function()
			vim.keymap.set("n", "c+", "<Plug>(git-conflict-next-conflict)")
			vim.keymap.set("n", "c-", "<Plug>(git-conflict-prev-conflict)")
			vim.keymap.set("n", "cq", ":GitConflictListQf<CR>")
		end,
		config = { default_mappings = true, highlights = { incoming = "DiffText", current = "DiffAdd" } },
	},

	--- plugins that make vim easier to use
	{
		"chentoast/marks.nvim",
		keys = { "m" },
		cmd = "MarksListAll",
		init = function()
			vim.keymap.set("n", "m/", "<cmd>MarksListAll<CR>")
		end,
		config = {
			mappings = {
				set_next = "mm",
				next = "mn",
				prev = "mp",
				preview = false,
			},
		},
	},
	{
		"kylechui/nvim-surround",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gcc", "gbc" },
		config = true,
	},

	--- my plugins, they're awesome
	{
		"gennaro-tedesco/nvim-jqx",
		ft = { "json", "yaml" },
		config = function()
			require("nvim-jqx.config").use_quickfix = false
		end,
	},
}

local opts = {
	lockfile = vim.fs.normalize("~/dotfiles/nvim") .. "/lazy-lock.json",
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "⏰",
			ft = "📄",
			init = "⚙️",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			source = "📁",
			start = "🚀",
			task = "📌",
		},
	},
	checker = {
		enabled = true,
		notify = false,
	},
	diff = {
		cmd = "terminal_git",
	},
}

lazy.setup(plugins, opts)

for _, file in ipairs(vim.fn.readdir(config_path .. "/lua", [[v:val =~ '\.lua$']])) do
	require(file:gsub("%.lua$", ""))
end

local function plug_list()
	vim.cmd.edit(config_path .. "/init.lua")

	local loc_list = {}
	for _, p in pairs(lazy.plugins()) do
		local plugin_pattern = '"' .. p[1]:gsub("/", "\\/") .. '"'
		local row = vim.fn.search(plugin_pattern)
		local col =
			tonumber(vim.api.nvim_exec("g/" .. plugin_pattern .. '/execute "normal! ^" | echo col(".")-1', true))
		if row ~= 0 then
			table.insert(loc_list, {
				bufnr = vim.api.nvim_buf_get_number(0),
				lnum = row,
				col = col + 1,
				text = p[1],
			})
		end
	end
	vim.fn.setloclist(0, loc_list, " ")
	vim.cmd("lopen")
end

vim.api.nvim_create_user_command("PlugList", plug_list, {})
