local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

local symbols_exclude = { "Constant", "Variable", "String", "Number", "Text", "Boolean" }

local M = {}

M.opts = {
	hls = {
		normal = "Normal",
		preview_normal = "Normal",
		border = "Function",
		preview_border = "Function",
	},
	winopts = {
		height = 0.25,
		width = 0.6,
		row = 0.5,
		preview = { hidden = "hidden" },
		border = "rounded",
		treesitter = { enabled = true },
	},
	fzf_opts = {
		["--no-info"] = "",
		["--info"] = "hidden",
		["--padding"] = "13%,5%,13%,5%",
		["--no-header"] = "",
		["--no-scrollbar"] = "",
	},
	files = {
		formatter = "path.filename_first",
		git_icons = false,
		prompt = ":",
		no_header = true,
		cwd_header = false,
		cwd_prompt = false,
		cwd = require("utils").git_root(),
		winopts = {
			title = " files 📑 ",
			title_pos = "center",
			title_flags = false,
		},
		actions = {
			["ctrl-d"] = {
				fn = function(...)
					fzf.actions.file_vsplit(...)
					vim.cmd("windo diffthis")
					local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
					vim.api.nvim_feedkeys(switch, "t", false)
				end,
				desc = "diff-file",
			},
		},
	},
	buffers = {
		formatter = "path.filename_first",
		prompt = ":",
		no_header = true,
		fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
		winopts = {
			title = " buffers 📝 ",
			title_pos = "center",
		},
		actions = {
			["ctrl-d"] = {
				fn = function(...)
					fzf.actions.file_vsplit(...)
					vim.cmd("windo diffthis")
					local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
					vim.api.nvim_feedkeys(switch, "t", false)
				end,
				desc = "diff-file",
			},
		},
	},
	helptags = {
		prompt = ":",
		winopts = {
			title = " help 💡 ",
			title_pos = "center",
			height = 0.6,
			preview = {
				hidden = "nohidden",
				horizontal = "down:40%",
			},
		},
	},
	git = {
		branches = {
			prompt = ":",
			cmd = "git branch -a --format='%(refname:short)'",
			no_header = true,
			winopts = {
				title = " branches  ",
				title_pos = "center",
				preview = { hidden = "hidden" },
			},
			actions = {
				["default"] = {
					fn = function(selected)
						vim.fn.system("git checkout " .. selected[1])
						vim.cmd.checktime()
					end,
					desc = "git-checkout-branch",
				},
			},
		},
	},
	lsp = {
		symbols = {
			cwd_only = true,
			no_header = true,
			regex_filter = function(item)
				if vim.tbl_contains(symbols_exclude, item.kind) then
					return false
				else
					return true
				end
			end,
			prompt = ":",
			winopts = {
				title = " symbols ✨ ",
				title_pos = "center",
				height = 0.6,
				preview = {
					hidden = "nohidden",
					horizontal = "down:40%",
					wrap = "wrap",
				},
			},
			symbol_hl = function(s)
				return "@lsp.type." .. s:lower()
			end,
			symbol_fmt = function(s)
				return s .. ":"
			end,
			symbol_style = 2,
			symbol_icons = require("utils").icons.kinds,
			child_prefix = false,
		},
	},
	autocmds = {
		prompt = ":",
		winopts = {
			title = " autocommands ",
			title_pos = "center",
			height = 0.6,
			preview = {
				hidden = "nohidden",
				layout = "horizontal",
				horizontal = "down:40%",
				wrap = "wrap",
			},
		},
	},
	keymaps = {
		prompt = ":",
		winopts = {
			title = " keymaps ",
			title_pos = "center",
			height = 0.6,
			preview = {
				hidden = "nohidden",
				layout = "horizontal",
				horizontal = "down:40%",
			},
		},
		actions = {
			["default"] = {
				fn = function(selected)
					local lines = vim.split(selected[1], "│", {})
					local mode, key = lines[1]:gsub("%s+", ""), lines[2]:gsub("%s+", "")
					vim.cmd("verbose " .. mode .. "map " .. key)
				end,
				desc = "print-keymap-location",
			},
		},
	},
	highlights = {
		prompt = ":",
		winopts = {
			title = " highlights 🎨 ",
			title_pos = "center",
			height = 0.6,
			preview = {
				hidden = "nohidden",
				layout = "horizontal",
				horizontal = "down:40%",
				wrap = "wrap",
			},
		},
	},
	registers = {
		prompt = "registers:",
		filter = "%a",
		winopts = {
			title = " registers 🏷️ ",
			title_pos = "center",
		},
	},
}

M.keys = {
	{
		"<C-p>",
		function()
			fzf.files()
		end,
		desc = "fzf browse files",
	},
	{
		"<C-b>",
		function()
			fzf.buffers()
		end,
		desc = "fzf browse buffers",
	},
	{
		"<F1>",
		function()
			fzf.help_tags()
		end,
		desc = "fzf help tags",
	},
	{
		'""',
		function()
			fzf.registers()
		end,
		desc = "fzf show registers",
	},
	{
		"<leader>gB",
		function()
			if require("utils").git_root() ~= nil then
				fzf.git_branches()
			else
				vim.notify("not a git repository", vim.log.levels.WARN)
			end
		end,
		desc = "fzf git branches",
	},
	{
		"<C-m>",
		function()
			vim.ui.input({ prompt = "search symbol: " }, function(sym)
				if not sym or sym == "" then
					return
				end
				fzf.lsp_workspace_symbols({ lsp_query = sym })
			end)
		end,
		desc = "fzf workspace symbols",
	},
	{
		"gm",
		function()
			fzf.lsp_document_symbols()
		end,
		desc = "fzf document symbols",
	},
	{
		"/",
		ft = "qf",
		function()
			require("plugins.fzf_extras").filter_qf()
		end,
		desc = "fzf filter quickfix",
	},
}

--- registering custom providers
require("fzf-lua").env = function()
	require("plugins.fzf_extras").printenv()
end

return M
