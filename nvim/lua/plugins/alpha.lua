local ok, alpha = pcall(require, "alpha")
if not ok then
	return
end

local theta = require("alpha.themes.theta")
local dashboard = require("alpha.themes.dashboard")

local header =
	{ type = "text", val = { "welcome back, and a fine day it is!" }, opts = { position = "center", hl = "@type" } }
local footer = {
	type = "text",
	val = {
		require("utils").version(),
	},
	opts = { position = "center", hl = "@type" },
}

local files = {
	type = "group",
	val = {
		{ type = "text", val = "recent files", opts = { hl = "@constructor", position = "center" } },
		{ type = "padding", val = 1 },
		theta.mru(0, vim.fn.getcwd(), 10),
	},
}

local buttons = {
	type = "group",
	val = {
		{ type = "text", val = "actions", opts = { hl = "@constructor", position = "center" } },
		{ type = "padding", val = 1 },
		dashboard.button("e", "📄 new file", ":ene <BAR> startinsert <CR>"),
		dashboard.button("t", "📝 todo", ":e<space>~/.todo<CR>"),
		dashboard.button("p", "🔌 plugins", "<cmd>Lazy<CR>"),
		dashboard.button("h", "✅ checkhealth", "<cmd>checkhealth<CR>"),
		dashboard.button("q", "❌ quit", "<cmd>qa<CR>"),
	},
}

theta.config = {
	layout = {
		{ type = "padding", val = 2 },
		header,
		{ type = "padding", val = 3 },
		files,
		{ type = "padding", val = 2 },
		buttons,
		{ type = "padding", val = 2 },
		footer,
	},
}

alpha.setup(theta.config)
