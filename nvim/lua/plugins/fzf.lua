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
		prompt = ":",
		no_header = true,
		cwd_header = false,
		cwd_prompt = false,
		cwd = require("utils").git_root(),
		winopts = {
			title = " files 📑 ",
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
	buffers = {
		formatter = "path.filename_first",
		prompt = ":",
		no_header = true,
		fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
		winopts = {
			title = " buffers 📝 ",
			title_pos = "center",
		},
	},
	helptags = {
		prompt = ":",
		winopts = {
			title = " help 💡 ",
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
			prompt = ":",
			cmd = "git branch -a --format='%(refname:short)'",
			no_header = true,
			winopts = {
				title = " branches  ",
				title_pos = "center",
				preview = {
					hidden = "hidden",
					layout = "vertical",
					vertical = "right:50%",
					wrap = "wrap",
				},
				row = 1,
				width = 0.3,
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
		prompt = ":",
		winopts = {
			title = " autocommands ",
			title_pos = "center",
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
		prompt = ":",
		winopts = {
			title = " keymaps ",
			title_pos = "center",
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
		prompt = ":",
		winopts = {
			title = " highlights 🎨 ",
			title_pos = "center",
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
		filter = "%a",
		winopts = {
			title = " registers 🏷️ ",
			title_pos = "center",
			width = 0.8,
		},
	},
})
