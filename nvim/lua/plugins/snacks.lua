local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
	return
end

local in_git = snacks.git.get_root() ~= nil

snacks.setup({
	styles = {
		["notification.history"] = {
			title = "Notifications",
			keys = { q = "close", ["<Esc>"] = "close" },
		},
	},
	words = { enabled = true, notify_end = false },
	quickfile = { enabled = true, exclude = { "latex" } },
	notifier = {
		enabled = true,
		style = "minimal",
		icons = {
			error = "",
			info = "",
		},
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
			{ section = "recent_files", limit = 8, indent = 4, padding = 2 },
			{ title = "🔖 Quick commands", padding = 1 },
			{ section = "keys", indent = 4, padding = 2 },
			{
				icon = "🧿",
				title = "Git status:  " .. vim.system({ "git", "branch", "--show-current" }, { text = true })
					:wait().stdout,
				enabled = in_git,
				padding = 1,
			},
			{
				desc = "🔱 git diff",
				enabled = in_git,
				indent = 4,
				padding = 1,
				key = "d",
				action = function()
					require("fzf-lua").fzf_exec("git branch -a --format='%(refname:short)'", {
						prompt = "diff branch:",
						actions = {
							["default"] = function(selected)
								vim.cmd.DiffviewOpen({ args = { selected[1] } })
							end,
						},
					})
				end,
			},
			{
				section = "terminal",
				enabled = in_git,
				cmd = "git status --short",
				height = 5,
				padding = 1,
				indent = 3,
			},
		},
	},
})
