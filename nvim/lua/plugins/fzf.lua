local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

fzf.setup({
	hls = { normal = "Pmenu", preview_normal = "Pmenu" },
	winopts = {
		height = 0.25,
		width = 0.4,
		row = 0.5,
		preview = { hidden = "hidden" },
		border = "none",
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
			["ctrl-d"] = function(...)
				fzf.actions.file_vsplit(...)
				vim.cmd("windo diffthis")
				local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
				vim.api.nvim_feedkeys(switch, "t", false)
			end,
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
			preview = {
				hidden = "hidden",
			},
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
					fzf.actions.git_buf_vsplit(...)
					vim.cmd("windo diffthis")
					local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
					vim.api.nvim_feedkeys(switch, "t", false)
				end,
			},
			winopts = {
				preview = {
					hidden = "nohidden",
					layout = "vertical",
					vertical = "right:50%",
					wrap = "wrap",
				},
				row = 1,
				width = vim.api.nvim_win_get_width(0),
				height = 0.3,
			},
		},
		branches = {
			prompt = "branches:",
			cmd = "git branch --all --color",
			winopts = {
				preview = {
					hidden = "nohidden",
					layout = "vertical",
					vertical = "right:50%",
					wrap = "wrap",
				},
				row = 1,
				width = vim.api.nvim_win_get_width(0),
				height = 0.3,
			},
		},
	},
	autocmds = {
		prompt = "autocommands:",
		winopts = {
			width = 0.8,
			height = 0.7,
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
		actions = {
			["default"] = function(selected)
				print(vim.cmd.highlight(selected[1]))
			end,
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
			height = 0.6,
		},
	},
	marks = {
		marks = "%a",
		winopts = {
			width = 0.8,
			height = 0.6,
			preview = {
				hidden = "nohidden",
				layout = "horizontal",
				horizontal = "down:40%",
			},
		},
	},
})
