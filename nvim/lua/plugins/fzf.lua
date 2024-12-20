local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

fzf.setup({
	hls = { normal = "Normal", preview_normal = "Normal", border = "Function", preview_border = "Function" },
	winopts = {
		height = 0.25,
		width = 0.4,
		row = 0.5,
		preview = { hidden = "hidden" },
		border = "rounded",
		treesitter = { enabled = true },
	},
	fzf_opts = {
		["--no-info"] = "",
		["--info"] = "hidden",
		["--padding"] = "13%,5%,13%,5%",
		["--header"] = " ",
		["--no-scrollbar"] = "",
	},
	files = {
		formatter = "path.filename_first",
		git_icons = true,
		prompt = "files:",
		no_header = true,
		cwd_header = false,
		cwd_prompt = false,
		cwd = require("utils").git_root(),
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
		prompt = "buffers:",
		no_header = true,
		fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
	},
	helptags = {
		prompt = "💡:",
		winopts = {
			title = " 💡 ",
			title_pos = "center",
			width = 0.8,
			height = 0.6,
			preview = {
				hidden = "nohidden",
				layout = "horizontal",
				horizontal = "down:40%",
			},
		},
	},
	git = {
		branches = {
			prompt = "branches:",
			cmd = "git branch -a --format='%(refname:short)'",
			no_header = true,
			winopts = {
				title = "  ",
				title_pos = "center",
				preview = {
					hidden = "hidden",
					layout = "vertical",
					vertical = "right:50%",
					wrap = "wrap",
				},
				row = 1,
				width = vim.api.nvim_win_get_width(0) / 2,
				height = 0.3,
			},
			actions = {
				["default"] = {
					fn = function(selected)
						vim.cmd.DiffviewOpen({ args = { selected[1] } })
					end,
					desc = "diffview-git-branch",
				},
			},
		},
	},
	autocmds = {
		prompt = "autocommands:",
		winopts = {
			width = 0.8,
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
		prompt = "keymaps:",
		winopts = {
			width = 0.8,
			height = 0.6,
			preview = {
				hidden = "nohidden",
				layout = "horizontal",
				horizontal = "down:40%",
			},
		},
		actions = {
			["default"] = function(selected)
				local lines = vim.split(selected[1], "│", {})
				local mode, key = lines[1]:gsub("%s+", ""), lines[2]:gsub("%s+", "")
				vim.cmd("verbose " .. mode .. "map " .. key)
			end,
		},
	},
	highlights = {
		prompt = "highlights:",
		winopts = {
			width = 0.8,
			height = 0.6,
			preview = {
				hidden = "nohidden",
				layout = "horizontal",
				horizontal = "down:40%",
				wrap = "wrap",
			},
		},
	},
	lsp = {
		code_actions = {
			prompt = "code actions:",
			winopts = {
				width = 0.8,
				height = 0.6,
				preview = {
					hidden = "nohidden",
					layout = "horizontal",
					horizontal = "down:75%",
				},
			},
		},
	},
	registers = {
		prompt = "registers:",
		winopts = {
			width = 0.8,
		},
	},
})
