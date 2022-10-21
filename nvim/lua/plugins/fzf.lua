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
