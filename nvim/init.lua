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
		opts = {
			transparent = true,
			on_highlights = function(highlights, colors)
				highlights.Visual = { bg = colors.base01, reverse = false }
			end,
			styles = {
				keywords = { italic = false },
				sidebars = "transparent",
				floats = "transparent",
			},
			sidebars = { "qf", "help" },
			day_brightness = 0,
		},
		init = function()
			vim.cmd([[colorscheme solarized-osaka]])
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
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({
				func_map = { open = "o", openc = "<CR>" },
				preview = { winblend = 0 },
			})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>T",
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
	{
		url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		event = "BufReadPost",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
				},
				highlight = {
					"DiagnosticWarn",
					"Tag",
					"Type",
					"Todo",
					"DiagnosticError",
					"DiagnosticHint",
				},
			}
		end,
	},

	--- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		build = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = "nvim-treesitter/nvim-treesitter",
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
		init = function()
			local treesitter_hl = vim.api.nvim_create_augroup("TreesitterHighlights", {})
			vim.api.nvim_clear_autocmds({ group = treesitter_hl })
			vim.api.nvim_create_autocmd("BufEnter", {
				group = treesitter_hl,
				desc = "redefinition of treesitter context highlights group",
				callback = function()
					vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Pmenu" })
				end,
			})
		end,
		opts = { max_lines = 3 },
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"Wansmer/treesj",
		keys = {
			{
				"<leader>m",
				function()
					vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "toggle treesj" })
				end,
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
		init = function()
			local markdown_hl = vim.api.nvim_create_augroup("MarkdownHighlights", {})
			vim.api.nvim_clear_autocmds({ group = markdown_hl })
			vim.api.nvim_create_autocmd("BufEnter", {
				group = markdown_hl,
				desc = "redefinition of markdown highlights",
				callback = function()
					vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { link = "DiagnosticVirtualTextInfo" })
					vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { link = "DiagnosticVirtualTextHint" })
					vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { link = "DiagnosticVirtualTextHint" })
				end,
			})
		end,
		opts = {
			completions = { blink = { enabled = true } },
			heading = {
				sign = false,
				icons = { "", "", "" },
				width = "block",
				right_pad = 2,
			},
			code = { sign = false },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	},

	--- LSP, language servers and code autocompletion
	{
		"folke/lazydev.nvim",
		ft = "lua",
		config = true,
	},
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "*",
		dependencies = {
			"windwp/nvim-autopairs",
			config = function()
				require("plugins.autopairs")
			end,
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
		"cameron-wags/rainbow_csv.nvim",
		event = "BufReadPost",
		init = function()
			vim.g.rainbow_hover_debounce_ms = 1000
			vim.g.disable_rainbow_key_mappings = 1
		end,
		config = true,
		ft = {
			"csv",
			"tsv",
		},
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
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		keys = {
			{
				"<C-n>",
				function()
					require("nvim-tree.api").tree.toggle()
				end,
				desc = "toggle nvim-tree",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		config = function()
			require("plugins.nvim_tree")
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
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		cmd = { "DiffviewOpen" },
		init = function()
			vim.keymap.set(
				{ "n" },
				"<leader>gc",
				"<cmd>DiffviewFileHistory %<CR>",
				{ desc = "diffview buffer commits" }
			)
			vim.keymap.set({ "n" }, "<leader>gs", function()
				if next(require("diffview.lib").views) == nil then
					vim.cmd.DiffviewOpen()
				else
					if vim.fn.tabpagenr("$") > 1 then
						vim.cmd.DiffviewClose()
					else
						vim.cmd.quitall()
					end
				end
			end, { desc = "toggle diffview git status" })
		end,
		config = function()
			require("plugins.diffview")
		end,
	},
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
		config = function()
			require("plugins.snacks")
		end,
		keys = {
			{
				"<leader>nh",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "show notification history",
				mode = "n",
			},
			{
				"<Esc>",
				function()
					Snacks.notifier.hide()
				end,
				desc = "dismiss notify popup",
				mode = "n",
			},
			{
				"<C-t>",
				function()
					if vim.bo.filetype ~= "fzf" then
						Snacks.terminal.toggle()
					end
				end,
				desc = "toggle snacks terminal",
				mode = { "n", "t" },
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1, true)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1, true)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
		},
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
			local matchup_hl = vim.api.nvim_create_augroup("MatchupHighlights", {})
			vim.api.nvim_clear_autocmds({ group = matchup_hl })
			vim.api.nvim_create_autocmd("BufEnter", {
				group = matchup_hl,
				desc = "redefinition of treesitter context highlights group",
				callback = function()
					vim.api.nvim_set_hl(0, "MatchWord", { bold = false, reverse = true })
					vim.api.nvim_set_hl(0, "MatchParen", { bold = false, reverse = true })
					vim.api.nvim_set_hl(0, "MatchupVirtualText", { bold = false, reverse = true })
				end,
			})
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_surround_enabled = 1
		end,
	},

	--- my plugins, they're awesome
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
				autoload = false,
				autosave = false,
				autoswitch = { enable = true },
				---@type possession.Hls
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

--- require the entire lua directory
for _, file in ipairs(vim.fn.readdir(config_path .. "/lua", [[v:val =~ '\.lua$']])) do
	require(file:gsub("%.lua$", ""))
end
