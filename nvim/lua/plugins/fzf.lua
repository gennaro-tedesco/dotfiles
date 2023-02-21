local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

fzf.setup({
	winopts = {
		height = 0.25,
		width = 0.4,
		row = 0.5,
		hl = { normal = "Pmenu" },
		border = "none",
	},
	fzf_opts = {
		["--info"] = "hidden",
		["--padding"] = "10%,5%,10%,5%",
		["--header"] = " ",
		["--no-scrollbar"] = "",
	},
	files = {
		git_icons = true,
		prompt = "files:",
		preview_opts = "hidden",
	},
	buffers = {
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
					fzf.actions.git_buf_vsplit(...)
					vim.cmd("windo diffthis")
					local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
					vim.api.nvim_feedkeys(switch, "t", false)
				end,
			},
			preview_opts = "nohidden",
			winopts = {
				preview = {
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
			height = 0.7,
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
			height = 0.7,
			preview = {
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
	registers = {
		prompt = "registers:",
		preview_opts = "hidden",
		winopts = {
			width = 0.8,
			height = 0.7,
			preview = {
				layout = "horizontal",
				horizontal = "down:45%",
			},
		},
	},
})
