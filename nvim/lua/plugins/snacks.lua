local snacks_ok, _ = pcall(require, "snacks")
if not snacks_ok then
	return
end

local snacks_hl = vim.api.nvim_create_augroup("SnacksHighlights", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = snacks_hl,
	callback = function()
		vim.api.nvim_set_hl(0, "SnacksNotifierBorderInfo", { link = "DiagnosticHint" })
	end,
})

local M = {}

---@type snacks.Config
M.opts = {
	lazygit = {
		win = { height = 0 },
	},
	picker = {
		enabled = true,
		ui_select = true,
		win = { input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } } },
	},
	bufdelete = { enabled = true },
	---@type snacks.indent.Config
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
	---@type snacks.scroll.Config
	scroll = {
		animate = {
			easing = "inQuad",
		},
	},
	---@type snacks.notifier.style
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
	---@type snacks.notifier.Config
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
			Snacks.notifier.show_history()
		end,
		desc = "show notification history",
		mode = "n",
	},
	{
		"<leader>gs",
		function()
			Snacks.lazygit()
		end,
		desc = "open lazygit",
		mode = "n",
	},
	{
		"<Esc>",
		function()
			Snacks.notifier.hide()
		end,
		desc = "dismiss notify popup",
		mode = "n",
	},
	{
		",t",
		function()
			if vim.bo.filetype ~= "fzf" then
				Snacks.terminal.toggle()
			end
		end,
		desc = "toggle snacks terminal",
		mode = { "n", "t" },
	},
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1, true)
		end,
		desc = "Next Reference",
		mode = { "n", "t" },
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1, true)
		end,
		desc = "Prev Reference",
		mode = { "n", "t" },
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
