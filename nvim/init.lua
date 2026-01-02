----------------------------
----- initial settings -----
----------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.deprecate = function() end

---------------------------------
--- plugins manager:lazy.nvim ---
---------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local config_path = vim.fn.stdpath("config")
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
	--- colorschemes, syntax highlights and general UI
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = function()
			return require("plugins.colourscheme").opts
		end,
		init = function()
			vim.cmd.colorscheme("solarized-osaka")
		end,
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			filetypes = { "toml", "json", "gitconfig", "yaml", "html", "css" },
			user_default_options = { names = false },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			lazy = true,
		},
		config = function()
			require("plugins.lualine")
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({
				func_map = { open = "o", openc = "<CR>", stoggleup = "", stoggledown = "" },
				preview = { show_title = true, winblend = 0 },
			})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>t",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
		config = function()
			require("plugins.flash")
		end,
	},

	--- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		branch = "main",
		config = function()
			require("plugins.treesitter_textobjects")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		keys = {
			{
				"[c",
				function()
					require("treesitter-context").go_to_context()
				end,
			},
		},
		opts = { max_lines = 3 },
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"Wansmer/treesj",
		keys = {
			{
				"<leader>m",
				function()
					require("treesj").toggle()
				end,
				desc = "toggle treesj",
			},
		},
		opts = { use_default_keymaps = false },
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"m-demare/hlargs.nvim",
		event = "BufReadPost",
		opts = { highlight = { link = "NonText" } },
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		opts = {
			completions = { blink = { enabled = true } },
			heading = {
				position = "inline",
				sign = false,
				icons = { "", "", "", "" },
				width = "block",
				backgrounds = {},
			},
			code = { sign = false },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-neorg/neorg",
		branch = "main",
		ft = "norg",
		cmd = "Neorg",
		opts = function()
			return require("plugins.neorg").opts
		end,
	},

	--- LSP, language servers and code autocompletion
	{
		"folke/lazydev.nvim",
		ft = "lua",
		config = true,
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "*",
		dependencies = {
			{
				"windwp/nvim-autopairs",
				config = function()
					require("plugins.autopairs")
				end,
			},
		},
		config = function()
			require("plugins.blink")
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
	{
		"folke/sidekick.nvim",
		opts = function()
			return require("plugins.sidekick").opts
		end,
		keys = function()
			return require("plugins.sidekick").keys
		end,
	},

	--- linting and formatting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.nvim_lint")
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			require("plugins.conform")
		end,
	},

	--- file navigation
	{
		"ibhagwan/fzf-lua",
		branch = "main",
		lazy = true,
		opts = function()
			return require("plugins.fzf").opts
		end,
		keys = function()
			return require("plugins.fzf").keys
		end,
	},
	{
		"chrisgrieser/nvim-spider",
		lazy = true,
		init = function()
			vim.keymap.set({ "n", "o", "x" }, "w", function()
				require("spider").motion("w")
			end, { desc = "Spider-w" })
			vim.keymap.set({ "n", "o", "x" }, "e", function()
				require("spider").motion("e")
			end, { desc = "Spider-e" })
			vim.keymap.set({ "n", "o", "x" }, "b", function()
				require("spider").motion("b")
			end, { desc = "Spider-b" })
			vim.keymap.set({ "n", "o", "x" }, "ge", function()
				require("spider").motion("ge")
			end, { desc = "Spider-ge" })
		end,
	},

	--- git integration
	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.gitsigns")
		end,
		keys = {
			{
				"<leader>h/",
				function()
					require("gitsigns").setqflist("all")
				end,
			},
		},
	},

	--- plugins that make vim easier to use
	{
		---@module 'snacks'
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = function()
			return require("plugins.snacks").opts
		end,
		keys = function()
			return require("plugins.snacks").keys
		end,
		init = function()
			vim.api.nvim_create_user_command("Bd", function()
				Snacks.bufdelete()
			end, {})
		end,
	},
	{
		"stevearc/quicker.nvim",
		opts = {
			type_icons = {
				E = "✘",
				W = "",
				H = "i",
				I = "i",
				N = "i",
			},
		},
	},
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		init = function()
			vim.keymap.set("n", "m/", "<cmd>MarksListAll<CR>")
		end,
		opts = {
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
		version = "*",
		event = "VeryLazy",
		config = true,
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_surround_enabled = 1
		end,
		opts = {
			treesitter = {
				stopline = 500,
			},
		},
	},
	{
		"gennaro-tedesco/nvim-possession",
		keys = {
			{
				"<leader>sl",
				function()
					require("nvim-possession").list()
				end,
				desc = "📌list sessions",
			},
			{
				"<leader>sn",
				function()
					require("nvim-possession").new()
				end,
				desc = "📌create new session",
			},
			{
				"<leader>su",
				function()
					require("nvim-possession").update()
				end,
				desc = "📌update current session",
			},
			{
				"<leader>sd",
				function()
					require("nvim-possession").delete()
				end,
				desc = "📌delete selected session",
			},
		},
		config = function()
			require("nvim-possession").setup({
				autoload = true,
				autosave = false,
				autoswitch = { enable = true },
				fzf_hls = { border = "Function", preview_border = "Function" },
				fzf_winopts = { width = 0.4 },
				sort = require("nvim-possession.sorting").time_sort,
			})
		end,
	},
}

local opts = {
	lockfile = vim.fs.normalize("~/dotfiles/nvim") .. "/lazy-lock.json",
	ui = {
		border = "rounded",
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
	headless = {
		process = false,
		log = false,
	},
	diff = {
		cmd = "terminal_git",
	},
	dev = {
		path = "~",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"osc52",
			},
		},
	},
	profiling = {
		loader = true,
		require = true,
	},
}

lazy.setup(plugins, opts)
vim.cmd.packadd("nvim.undotree")

--- require the entire lua directory
for _, file in ipairs(vim.fn.readdir(config_path .. "/lua")) do
	if file:match("%.lua$") then
		require(file:gsub("%.lua$", ""))
	end
end
