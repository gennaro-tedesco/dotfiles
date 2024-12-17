local snacks_ok, snacks = pcall(require, "snacks")
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

snacks.setup({
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
	---@type snacks.statuscolumn.Config
	statuscolumn = { enabled = true },
	---@type snacks.scroll.Config
	scroll = {
		animate = { easing = "inQuad" },
	},
	---@type snacks.notifier.style
	styles = {
		["notification"] = {
			wo = { wrap = true },
		},
		["notification.history"] = {
			width = 0.8,
			title = " Notifications ",
			keys = { q = "close", ["<Esc>"] = "close" },
			wo = { wrap = true },
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
		win = {
			position = "float",
			height = 0.85,
			width = 0.9,
			border = "rounded",
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
			{
				section = "terminal",
				cmd = "curl -s 'wttr.in/?0'",
				indent = 15,
			},
		},
	},
})
