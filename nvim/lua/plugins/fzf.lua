local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

local icons = require("utils").icons

fzf.setup({
	hls = {
		normal = "Normal",
		preview_normal = "Normal",
		border = "Function",
		preview_border = "Function",
	},
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
				["ctrl-d"] = {
					fn = function(selected)
						vim.cmd.DiffviewOpen({ args = { selected[1] } })
					end,
					desc = "diffview-git-branch",
				},
			},
		},
	},
	lsp = {
		symbols = {
			cwd_only = true,
			no_header = true,
			regex_filter = function(item)
				if
					item.kind:match("Variable")
					or item.kind:match("String")
					or item.kind:match("Number")
					or item.kind:match("Boolean")
				then
					return false
				else
					return true
				end
			end,
			prompt = ":",
			winopts = {
				title = " symbols ✨ ",
				title_pos = "center",
				width = 0.8,
				height = 0.6,
				preview = {
					hidden = "nohidden",
					horizontal = "down:40%",
					wrap = "wrap",
				},
			},
			symbol_fmt = function(s)
				return s .. ":"
			end,
			symbol_style = 2,
			symbol_icons = icons.kinds,
			child_prefix = false,
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

--- initialisation of fzf commands
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
	if require("utils").git_root() ~= nil then
		fzf.git_branches()
	else
		vim.notify("not a git repository", vim.log.levels.WARN)
	end
end, { desc = "fzf git branches" })
vim.keymap.set({ "n" }, "<C-m>", function()
	vim.ui.input({ prompt = "search symbol: " }, function(sym)
		if not sym or sym == "" then
			return
		end
		fzf.lsp_workspace_symbols({ lsp_query = sym })
	end)
end, { desc = "fzf workspace symbols" })
vim.keymap.set({ "n" }, "gm", function()
	fzf.lsp_document_symbols()
end, { desc = "fzf document symbols" })
vim.api.nvim_create_user_command("Autocmd", function()
	fzf.autocmds()
end, { desc = "fzf autocmds list" })
vim.api.nvim_create_user_command("Maps", function()
	fzf.keymaps()
end, { desc = "fzf maps list" })
vim.api.nvim_create_user_command("Highlights", function()
	fzf.highlights()
end, { desc = "fzf highlights list" })

--- custom fzf pickers
local builtin = require("fzf-lua.previewer.builtin")
local EnvPreviewer = builtin.base:extend()

function EnvPreviewer:new(o, opts, fzf_win)
	EnvPreviewer.super.new(self, o, opts, fzf_win)
	setmetatable(self, EnvPreviewer)
	return self
end

function EnvPreviewer:populate_preview_buf(entry_str)
	local tmpbuf = self:get_tmp_buffer()
	local entry = vim.system({ "printenv", entry_str }, { text = true }):wait().stdout:gsub("[\n\r]", " ")
	vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, {
		" " .. entry,
	})
	self:set_preview_buf(tmpbuf)
	self.win:update_scrollbar()
end

function EnvPreviewer:gen_winopts()
	local new_winopts = {
		wrap = true,
		number = false,
	}
	return vim.tbl_extend("force", self.winopts, new_winopts)
end

local function printenv()
	local cmd = "printenv | cut -d= -f1"
	local opts = {
		prompt = ":",
		previewer = EnvPreviewer,
		hls = { cursorline = "" },
		winopts = {
			title = " env variables ",
			title_pos = "center",
			height = 0.4,
			preview = {
				hidden = "nohidden",
				horizontal = "down:5%",
			},
		},
		actions = {
			["default"] = function(selected)
				vim.notify(
					vim.system({ "printenv", selected[1] }, { text = true }):wait().stdout:gsub("[\n\r]", " "),
					vim.log.levels.INFO,
					{ ft = "bash" }
				)
			end,
		},
	}
	fzf.fzf_exec(cmd, opts)
end

vim.api.nvim_create_user_command("Env", printenv, {})
