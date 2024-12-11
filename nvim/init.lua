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
		"folke/noice.nvim",
		dependencies = {
			{ "MunifTanjim/nui.nvim" },
		},
		config = function()
			require("plugins.noice")
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
	{
		url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
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
		opts = {
			heading = {
				sign = false,
				icons = { "  ", "   ", "    ", "     " },
				width = "block",
				right_pad = 2,
			},
			code = { sign = false },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	},

	--- LSP, language servers and code autocompletion
	{ "nvim-lua/plenary.nvim" },
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		config = function()
			require("plugins.lsp")
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "BufReadPre",
		priority = 1000,
		opts = {
			preset = "classic",
			signs = {
				diag = "●",
				arrow = "  ",
				left = "",
				right = "",
			},
			options = {
				show_source = false,
				multiple_diag_under_cursor = true,
				multilines = false,
				show_all_diags_on_cursorline = true,
			},
		},
		init = function()
			local tiny_hl = vim.api.nvim_create_augroup("TinyHighlights", {})
			vim.api.nvim_clear_autocmds({ group = tiny_hl })
			vim.api.nvim_create_autocmd("BufEnter", {
				group = tiny_hl,
				desc = "redefinition of tiny diagnostics highlights group",
				callback = function()
					vim.api.nvim_set_hl(
						0,
						"TinyInlineDiagnosticVirtualTextError",
						{ bg = "none", fg = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }).fg }
					)
					vim.api.nvim_set_hl(
						0,
						"TinyInlineDiagnosticVirtualTextWarn",
						{ bg = "none", fg = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextWarn" }).fg }
					)
					vim.api.nvim_set_hl(
						0,
						"TinyInlineDiagnosticVirtualTextHint",
						{ bg = "none", fg = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextHint" }).fg }
					)
				end,
			})
		end,
	},
	{ "smjonas/inc-rename.nvim", event = "InsertEnter", config = true },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		config = true,
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
			"lukas-reineke/cmp-under-comparator",
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
		"hedyhli/outline.nvim",
		cmd = "Outline",
		keys = {
			{
				"gm",
				function()
					require("nvim-tree.api").tree.close()
					vim.cmd.Outline()
				end,
				desc = "open outline view",
			},
		},
		init = function()
			local outline_hl = vim.api.nvim_create_augroup("OutlineHighlights", {})
			vim.api.nvim_clear_autocmds({ group = outline_hl })
			vim.api.nvim_create_autocmd("BufEnter", {
				group = outline_hl,
				desc = "redefinition of outline highlights group",
				callback = function()
					vim.api.nvim_set_hl(0, "OutlineJumpHighlight", { link = "Visual" })
				end,
			})
		end,
		config = function()
			require("plugins.outline")
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
		init = function()
			local fzf = require("fzf-lua")
			vim.keymap.set({ "n" }, "<C-p>", function()
				fzf.files()
			end, { desc = "fzf browse files" })
			vim.keymap.set({ "n" }, "<C-b>", function()
				fzf.buffers()
			end, { desc = "fzf browse open buffers" })
			vim.keymap.set({ "n" }, "<F1>", function()
				fzf.help_tags()
			end, { desc = "fzf help tags" })
			vim.keymap.set({ "n" }, '""', function()
				fzf.registers()
			end, { desc = "fzf show registers content" })
			vim.keymap.set({ "n" }, "<leader>gB", function()
				fzf.git_branches()
			end, { desc = "fzf git branches" })
			vim.api.nvim_create_user_command("Autocmd", function()
				fzf.autocmds()
			end, { desc = "fzf autocmds list" })
			vim.api.nvim_create_user_command("Maps", function()
				fzf.keymaps()
			end, { desc = "fzf maps list" })
			vim.api.nvim_create_user_command("Highlights", function()
				fzf.highlights()
			end, { desc = "fzf highlights list" })
		end,
		config = function()
			require("plugins.fzf")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		keys = {
			{
				"<C-n>",
				function()
					require("outline").close()
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
		"isakbm/gitgraph.nvim",
		dependencies = { "sindrets/diffview.nvim" },
		keys = {
			{
				"<leader>gl",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 1000 })
				end,
				desc = "git graph all",
			},
		},
		opts = {
			symbols = {
				merge_commit = "",
				commit = "",
			},
			hooks = {
				on_select_commit = function(commit)
					vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
				end,
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.gitsigns")
		end,
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
				"<F2>",
				function()
					Snacks.terminal.toggle()
				end,
				desc = "toggle snacks terminal",
				mode = { "n", "t" },
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
		},
	},
	{
		"stevearc/quicker.nvim",
		opts = {
			type_icons = {
				E = "❗",
				W = "⚠️ ",
				H = "i",
				I = "💡",
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
	{
		"rmagatti/alternate-toggler",
		cmd = "ToggleAlternate",
		keys = { { "<leader>b", "<cmd>ToggleAlternate<CR>", desc = "toggle alternate boolean" } },
		opts = {
			alternates = {
				["Right"] = "Left",
				["="] = "!=",
			},
		},
	},

	--- my plugins, they're awesome
	{
		"gennaro-tedesco/nvim-jqx",
		event = { "BufReadPost" },
		ft = { "json", "yaml" },
		config = function()
			local jqx = require("nvim-jqx.config")
			jqx.geometry.border = "single"
			jqx.use_quickfix = false
		end,
	},
	{
		"gennaro-tedesco/nvim-possession",
		init = function()
			vim.keymap.set("n", "<leader>sl", function()
				require("nvim-possession").list()
			end, { desc = "📌list sessions" })
			vim.keymap.set("n", "<leader>sn", function()
				require("nvim-possession").new()
			end, { desc = "📌create new session" })
			vim.keymap.set("n", "<leader>su", function()
				require("nvim-possession").update()
			end, { desc = "📌update current session" })
			vim.keymap.set("n", "<leader>sd", function()
				require("nvim-possession").delete()
			end)
		end,
		opts = {
			autoload = false,
			autosave = false,
			autoswitch = { enable = true },
			fzf_winopts = { hl = { border = "Constant" } },
		},
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
}

lazy.setup(plugins, opts)

for _, file in ipairs(vim.fn.readdir(config_path .. "/lua", [[v:val =~ '\.lua$']])) do
	require(file:gsub("%.lua$", ""))
end

local function install()
	local make_cmd = vim.system({ "make", "-C", vim.fs.normalize("~/dotfiles"), "nvim" }, { text = true }):wait()
	if make_cmd.code ~= 0 then
		vim.notify(
			make_cmd.stderr,
			vim.log.levels.ERROR,
			{ ft = "bash", style = "compact", title = "install nvim config", id = "nvim" }
		)
		return
	end
	vim.notify(
		make_cmd.stdout:gsub("\n[^\n]*$", ""),
		vim.log.levels.INFO,
		{ ft = "bash", style = "compact", title = "install nvim config", id = "nvim" }
	)
end
nnoremap("<leader>i", install, { desc = "install nvim dotfiles" })
