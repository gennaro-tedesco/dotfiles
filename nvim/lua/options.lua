-- ------------------------------------------
-- customisation of default plugins options -
-- ------------------------------------------

Icons = {
	Class = "ﴯ",
	Color = "",
	Constant = "",
	Constructor = "",
	Enum = "",
	EnumMember = "",
	Event = "",
	Field = "",
	File = "",
	Folder = "",
	Function = "",
	Interface = "",
	Keyword = "",
	Method = "",
	Module = "",
	Operator = "",
	Property = "ﰠ",
	Reference = "",
	Snippet = "",
	Struct = "",
	Text = "",
	TypeParameter = "",
	Unit = "",
	Value = "",
	Variable = "",
}

vim.g.python3_host_prog = "/usr/local/bin/python3"

-- floaterm
vim.g.floaterm_autoclose = 2
vim.g.floaterm_keymap_toggle = "<F2>"
vim.g.floaterm_width = 0.85
vim.g.floaterm_height = 0.9
vim.g.floaterm_rootmarkers = { ".git" }
vim.g.floaterm_opener = "edit"
vim.g.floaterm_borderchars = "        "
vim.g.floaterm_title = ""

-- vimtex/zathura
vim.g.vimtex_view_general_viewer = "zathura"
vim.g.vimtex_view_zathura_options = "-reuse-instance"
vim.g.vimtex_imaps_leader = ","
vim.g.tex_conceal = ""
vim.g.tex_fast = ""
vim.g.tex_flavor = "latex"

-- treesitter
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	ensure_installed = { "go", "python", "json", "lua", "bash", "regex", "yaml", "vim" },
})

-- neoscroll
require("neoscroll").setup({
	mappings = { "<C-u>", "<C-d>", "<C-e>", "zt", "zz", "zb" },
})

-- quickfix windows
require("bqf").setup({ func_map = { openc = "<CR>" } })
require("pqf").setup({
	signs = { error = "✘", warning = ".", info = "i", hint = "💡" },
})
require("nvim-jqx.config").use_quickfix = false

-- git-conflict
require("git-conflict").setup({
	default_mappings = true,
	highlights = { incoming = "DiffText", current = "DiffAdd" },
})
vim.keymap.set("n", "c+", "<Plug>(git-conflict-next-conflict)")
vim.keymap.set("n", "c-", "<Plug>(git-conflict-prev-conflict)")
vim.keymap.set("n", "cq", ":GitConflictListQf<CR>")

-- git-signs
require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "_", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "++", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "--", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hp", gs.preview_hunk)
		map("n", "<leader>hl", function()
			gs.setloclist()
		end)
		map("n", "<leader>gB", function()
			gs.blame_line({ full = true })
		end)
	end,
})

-- marks
require("marks").setup({
	mappings = {
		set_next = "mm",
		next = "mn",
		prev = "mp",
		preview = false,
	},
})

vim.keymap.set("n", "m/", ":MarksListAll<CR>")

-- notify
require("notify").setup({
	timeout = 5000,
	render = "minimal",
	stages = "slide",
})

-- lastplace
require("nvim-lastplace").setup({
	lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
	lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
	lastplace_open_folds = true,
})

-- comments
require("Comment").setup()

-- auto-pairs
local npairs = require("nvim-autopairs")
npairs.setup({
	ignored_next_char = "[%w%.]",
})
npairs.setup({
	fast_wrap = {},
})
npairs.setup({
	fast_wrap = {
		map = "<C-w>",
		chars = { "{", "[", "(", '"', "'" },
		pattern = [=[[%'%"%)%>%]%)%}%,]]=],
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
	},
})

-- startify
local startify = require("alpha.themes.startify")
startify.section.header.val = { "welcome back, and a fine day it is!" }
startify.section.top_buttons.val = {
	startify.button("e", " New file", ":ene <BAR> startinsert <CR>"),
	startify.button("t", " Todo", ":e<space>~/.todo<CR>"),
}
startify.section.bottom_buttons.val = {
	startify.button("q", "✘ Quit NVIM", ":qa<CR>"),
	startify.button("h", "✔ checkhealth", ":checkhealth<CR>"),
}
startify.section.mru.val = { { type = "padding", val = 0 } }
startify.nvim_web_devicons.enabled = false
require("alpha").setup(require("alpha.themes.startify").config)

-- noice
local function no_msg(kind, regex)
	return {
		filter = { event = "msg_show", kind = kind, find = regex },
		opts = { skip = true },
	}
end

local noice_hl = vim.api.nvim_create_augroup("NoiceHighlights", {})
vim.api.nvim_clear_autocmds({ group = noice_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = noice_hl,
	callback = function()
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "Constant" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", { link = "Constant" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderLua", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderLua", { link = "Constant" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderFilter", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderFilter", { link = "Constant" })
	end,
})

local cmdline_opts = {
	border = {
		style = "rounded",
		text = { top = "" },
	},
}

require("noice").setup({
	cmdline = {
		view = "cmdline_popup",
		format = {
			cmdline = { pattern = "^:", icon = "", opts = cmdline_opts },
			search_down = { kind = "Search", pattern = "^/", icon = "🔎 ", ft = "regex", opts = cmdline_opts },
			search_up = { kind = "Search", pattern = "^%?", icon = "🔎 ", ft = "regex", opts = cmdline_opts },
			filter = { pattern = "^:%s*!", icon = "$", ft = "sh", opts = cmdline_opts },
			f_filter = { pattern = "^:%s*%%%s*!", icon = " $", ft = "sh", opts = cmdline_opts },
			v_filter = { pattern = "^:%s*%'<,%'>%s*!", icon = " $", ft = "sh", opts = cmdline_opts },
			lua = { pattern = "^:%s*lua%s+", icon = "", conceal = true, ft = "lua", opts = cmdline_opts },
			IncRename = {
				pattern = "^:%s*IncRename%s+",
				icon = " ",
				conceal = true,
				opts = {
					relative = "cursor",
					size = { min_width = 20 },
					position = { row = -3, col = 0 },
					buf_options = { filetype = "text" },
				},
			},
		},
	},
	messages = { view_search = false },
	lsp_progress = { view = "mini" },
	views = { split = { enter = true } },
	routes = {
		{ filter = { event = "msg_show", min_height = 10 }, view = "split" },
		no_msg(nil, "written"),
		no_msg(nil, "search hit BOTTOM"),
		no_msg("search_count", nil),
		no_msg("wmsg", nil),
		no_msg("emsg", "E23"),
		no_msg("emsg", "E20"),
		no_msg("emsg", "E37"),
	},
})

-- symbols outline
require("symbols-outline").setup({
	highlight_hovered_item = false,
	autofold_depth = 1,
	symbols = {
		Function = { icon = Icons.Function },
	},
})

-- lualine
local soldark = require("lualine.themes.solarized_dark")
soldark.normal.a.gui = ""
soldark.insert.a.gui = ""
soldark.visual.a.gui = ""
require("lualine").setup({
	extensions = { "quickfix", "fugitive" },
	options = {
		theme = soldark,
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", padding = { left = 1 } } },
		lualine_b = { "branch" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {
			{
				require("noice").api.statusline.mode.get,
				cond = require("noice").api.statusline.mode.has,
				color = { fg = "#2aa198" },
			},
			{
				"diagnostics",
				update_in_insert = true,
				symbols = { error = "❗:", warn = "⚠️ :", info = "i:", hint = "💡:" },
				colored = false,
			},
			{ "filetype" },
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- fzf
require("fzf-lua").setup({
	winopts = {
		height = 0.25,
		width = 0.4,
		row = 0.5,
		hl = { normal = "NormalFloat" },
		border = "none",
	},
	fzf_opts = {
		["--info"] = "hidden",
		["--padding"] = "10%,5%,10%,5%",
		["--header"] = " ",
	},
	files = {
		git_icons = false,
		prompt = "files:",
		preview_opts = "hidden",
	},
	buffers = {
		git_icons = false,
		prompt = "buffers:",
		preview_opts = "hidden",
	},
	helptags = {
		prompt = "💡:",
		preview_opts = "hidden",
		winopts = {
			row = 1,
			width = vim.api.nvim_win_get_width(0),
			height = 0.3,
		},
	},
	git = {
		bcommits = {
			prompt = "logs:",
			cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen%><(12)%cr%><|(12)%Creset %s' <file>",
			preview = "git show --stat --color --format='%C(cyan)%an%C(reset)%C(bold yellow)%d%C(reset): %s' {1} -- <file>",
			actions = {
				["ctrl-d"] = function(...)
					require("fzf-lua").actions.git_buf_vsplit(...)
					vim.cmd("windo diffthis")
				end,
			},
			preview_opts = "nohidden",
			winopts = {
				preview = {
					horizontal = "right:50%",
					wrap = "wrap",
				},
				row = 1,
				hl = { cursorline = "IncSearch" },
				width = vim.api.nvim_win_get_width(0),
				height = 0.3,
			},
		},
		branches = {
			prompt = "branches:",
			cmd = "git branch --all --color",
			winopts = {
				row = 1,
				width = vim.api.nvim_win_get_width(0),
				height = 0.3,
			},
		},
	},
	keymaps = {
		prompt = "keymaps:",
		winopts = {
			width = 0.8,
			height = 0.7,
		},
		actions = {
			["default"] = function(selected)
				local lines = vim.split(selected[1], "│", true)
				local mode, key = lines[1]:gsub("%s+", ""), lines[2]:gsub("%s+", "")
				print(vim.cmd("verbose " .. mode .. "map " .. key))
			end,
		},
	},
	registers = {
		prompt = "registers:",
		preview_opts = "hidden",
		winopts = {
			width = 0.8,
			height = 0.7,
			preview = {
				layout = "vertical",
				vertical = "down:45%",
			},
		},
	},
})

-- IncRename
require("inc_rename").setup()
