local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
	return
end

local snacks_hl = vim.api.nvim_create_augroup("SnacksHighlights", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = snacks_hl,
	callback = function()
		vim.api.nvim_set_hl(0, "SnacksNotifierBorderInfo", { link = "DiagnosticHint" })
		vim.api.nvim_set_hl(0, "SnacksPickerTree", { link = "WinSeparator" })
		vim.api.nvim_set_hl(0, "SnacksPickerInputCursorLine", { link = "Normal" })
		vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { link = "CursorLine" })
	end,
})

local M = {}

M.opts = {
	lazygit = {
		win = { height = 0 },
	},
	explorer = { enabled = true, replace_netrw = true },
	input = {
		enabled = false,
		icon = "",
		win = {
			keys = {
				n_esc = { "<esc>", "cancel", mode = "n" },
				i_esc = { "<esc>", "cancel", mode = "i" },
			},
		},
	},
	picker = {
		prompt = " ",
		enabled = true,
		ui_select = true,
		win = { input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } } },
		sources = {
			git_log_file = {
				actions = {
					diff_commit = function(picker, item)
						picker:close()
						require("gitsigns").diffthis(item.commit)
					end,
				},
				win = {
					input = {
						keys = {
							["<C-d>"] = { "diff_commit", mode = { "i", "n" } },
						},
					},
				},
			},
			explorer = {
				title = "🔎 search file",
				diagnostics = false,
				diagnostics_open = false,
				git_status = false,
				git_status_open = false,
				git_untracked = false,
				layout = { layout = { position = "right" } },
				win = {
					input = {
						keys = {
							["<Tab>"] = { "toggle_focus", mode = { "i" } },
							["<S-Tab>"] = { "toggle_focus", mode = { "i" } },
						},
					},
					list = {
						keys = {
							["<Tab>"] = false,
							["<S-Tab>"] = false,
							["d"] = false,
							["o"] = false,
							["m"] = false,
							["y"] = false,
							["c"] = false,
							["P"] = false,
							["dd"] = "explorer_del",
							["<Left>"] = "explorer_close",
							["<Right>"] = "confirm",
							["a"] = "explorer_add",
							["i"] = "explorer_rename",
							["za"] = "toggle_hidden",
							["<C-n>"] = "close",
							["v"] = { "select_and_next", mode = { "n", "x" } },
							["p"] = "explorer_move",
							["yf"] = { "explorer_yank", mode = { "n", "x" } },
							["yy"] = "explorer_copy",
						},
					},
				},
			},
		},
	},
	bufdelete = { enabled = true },
	indent = {
		enabled = true,
		indent = { enabled = false },
		scope = { enabled = false },
		chunk = {
			enabled = true,
			char = { corner_top = "╭", corner_bottom = "╰" },
			hl = "@comment.todo",
		},
	},
	scroll = {
		animate = {
			easing = "inQuad",
		},
	},
	styles = {
		["notification"] = {
			wo = { wrap = true },
			focusable = false,
		},
		["notification_history"] = {
			width = 0.8,
			title = " Notifications ",
			keys = { q = "close", ["<Esc>"] = "close" },
			wo = { wrap = true },
		},
		lazygit = {
			border = "rounded",
		},
	},
	words = { enabled = true, notify_end = false },
	quickfile = { enabled = true, exclude = { "latex" } },
	notifier = {
		enabled = true,
		style = function(buf, notif, ctx)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
		end,
		icons = {
			error = "",
			info = "",
			warn = "",
		},
		width = { min = 40, max = 70 },
	},
	terminal = {
		enabled = true,
		keys = {
			term_normal = {
				"<esc>",
				function(self)
					self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
					if self.esc_timer:is_active() then
						self.esc_timer:stop()
						vim.cmd("stopinsert")
					else
						self.esc_timer:start(200, 0, function() end)
						return "<esc>"
					end
				end,
				mode = "t",
				expr = true,
				desc = "snack terminal: double escape to normal mode",
			},
		},
		win = {
			position = "bottom",
			height = 0.4,
		},
	},
	dashboard = {
		enabled = true,
		preset = {
			header = "Welcome back, and a fine day it is!",
			keys = {
				{ icon = "📄", key = "e", desc = "new file", action = ":ene | startinsert" },
				{ icon = "📝", key = "t", desc = "todo", action = "<cmd>e ~/.todo<CR>" },
				{ icon = "✅", key = "h", desc = "checkhealth", action = "<cmd>checkhealth<CR>" },
				{
					icon = "🔌",
					key = "p",
					desc = "plugins",
					action = "<cmd>Lazy<CR>",
					enabled = package.loaded.lazy ~= nil,
				},
				{
					icon = " ",
					key = "b",
					desc = "git branches",
					action = function()
						require("fzf-lua").git_branches()
					end,
					enabled = function()
						return require("utils").git_root() ~= nil
					end,
				},
				{ icon = "❌", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
			},
		},
		sections = {
			{ section = "header" },
			{ title = "📂 Recent files", padding = 1 },
			{ section = "recent_files", limit = 8, indent = 4, padding = 2, cwd = true },
			{ title = "🔖 Quick commands", padding = 1 },
			{ section = "keys", indent = 4, padding = 2 },
		},
	},
}

M.keys = {
	{
		"<leader>nh",
		function()
			snacks.notifier.show_history()
		end,
		desc = "show notification history",
		mode = "n",
	},
	{
		"<leader>gs",
		function()
			snacks.lazygit()
		end,
		desc = "open lazygit",
		mode = "n",
	},
	{
		"<leader>gc",
		function()
			snacks.picker.git_log_file()
		end,
		desc = "open buffer commits",
		mode = "n",
	},
	{
		"<Esc>",
		function()
			snacks.notifier.hide()
		end,
		desc = "dismiss notify popup",
		mode = "n",
	},
	{
		",t",
		function()
			if vim.bo.filetype ~= "fzf" then
				snacks.terminal.toggle()
			end
		end,
		desc = "toggle snacks terminal",
		mode = { "n", "t" },
	},
	{
		"]]",
		function()
			snacks.words.jump(vim.v.count1, true)
		end,
		desc = "Next Reference",
		mode = { "n", "t" },
	},
	{
		"[[",
		function()
			snacks.words.jump(-vim.v.count1, true)
		end,
		desc = "Prev Reference",
		mode = { "n", "t" },
	},
	{
		"<C-n>",
		function()
			snacks.explorer()
		end,
		desc = "File Explorer",
	},
}

--- lsp progress
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {}
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), "info", {
			style = "compact",
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

return M
