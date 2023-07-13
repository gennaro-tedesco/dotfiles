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
	-- colorschemes, syntax highlights and general UI
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
		build = ":TSUpdate",
		event = "BufReadPost",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				event = "BufReadPre",
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
				config = true,
			},
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
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
			},
			{ "RRethy/nvim-treesitter-textsubjects" },
			{ "m-demare/hlargs.nvim", event = "BufReadPost", opts = { highlight = { link = "NonText" } } },
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
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({ func_map = { open = "o", openc = "<CR>" } })
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "BufReadPre",
		init = function()
			vim.keymap.set("n", "g<Tab>", function()
				require("dropbar.api").pick()
			end)
		end,
		config = function()
			require("plugins.dropbar")
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

	--- LSP, language servers and code autocompletion
	{ "nvim-lua/plenary.nvim" },
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "smjonas/inc-rename.nvim", event = "InsertEnter", config = true },
			{ "folke/neodev.nvim", event = "InsertEnter", ft = "lua", config = true },
			{
				"weilbith/nvim-code-action-menu",
				cmd = "CodeActionMenu",
				init = function()
					vim.g.code_action_menu_show_diff = true
					vim.g.code_action_menu_window_border = "rounded"
					local actions_hl = vim.api.nvim_create_augroup("ActionsHighlight", { clear = true })
					vim.api.nvim_create_autocmd("User", {
						pattern = "CodeActionMenuWindowOpened",
						group = actions_hl,
						callback = function()
							vim.api.nvim_set_hl(0, "CodeActionMenuMenuSelection", { link = "PmenuSel" })
						end,
					})
				end,
			},
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
			vim.keymap.set({ "n" }, "<leader>gb", function()
				fzf.git_branches()
			end, { desc = "fzf git branches" })
			vim.keymap.set({ "n" }, "<leader>gc", function()
				fzf.git_bcommits()
			end, { desc = "fzf buffer commits" })
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
		"numToStr/FTerm.nvim",
		keys = { "<F2>" },
		config = function()
			require("FTerm").setup({ border = "rounded", dimensions = { height = 0.85, width = 0.9 } })
			vim.keymap.set("n", "<F2>", '<cmd>lua require("FTerm").toggle()<CR>', { desc = "toggle fterm" })
			vim.keymap.set("t", "<F2>", '<C-\\><C-n><cmd>lua require("FTerm").toggle()<CR>', { desc = "toggle fterm" })
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		init = function()
			vim.keymap.set("n", "<C-n>", function()
				require("nvim-tree.api").tree.toggle()
			end, { desc = "toggle nvim-tree" })
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
			vim.keymap.set("n", "<C-*>", "<cmd>Rg<space><CR>")
			vim.keymap.set("n", "<C-g>", "<cmd> lua require('utils').replace_grep()<CR>")
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
		"tpope/vim-fugitive",
		init = function()
			vim.keymap.set("n", "<leader>gs", "<cmd> Git<CR>")
			vim.keymap.set("n", "<leader>gp", "<cmd> Git push<CR>")
		end,
	},
	{
		"sindrets/diffview.nvim",
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
	},
	{
		"akinsho/git-conflict.nvim",
		tag = "v1.1.2",
		opts = {
			default_mappings = { ours = "co", theirs = "ct", none = "c0", both = "cb", next = "c+", prev = "c-" },
		},
	},

	--- plugins that make vim easier to use
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
		event = "BufReadPost",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		keys = { "gc", "gb", { "gc", mode = "v" }, { "gb", mode = "v" } },
		config = true,
	},
	{
		"andymass/vim-matchup",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_surround_enabled = 1
		end,
	},

	--- my plugins, they're awesome
	{
		"gennaro-tedesco/nvim-jqx",
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
			autoload = true,
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
	local mk_path, mk_cmd = vim.fs.normalize("~/dotfiles"), "nvim"
	vim.cmd("!make -C " .. mk_path .. " " .. mk_cmd)
end
nnoremap("<leader>i", install, { desc = "install nvim dotfiles" })
