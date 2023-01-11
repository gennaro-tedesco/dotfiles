local ok, alpha = pcall(require, "alpha")
if not ok then
	return
end

local startify = require("alpha.themes.startify")
startify.section.header.val = { "welcome back, and a fine day it is!" }
startify.section.top_buttons.val = {
	startify.button("e", "📄 new file", ":ene <BAR> startinsert <CR>"),
	startify.button("t", "📆 todo", ":e<space>~/.todo<CR>"),
	startify.button("s", "📌 sessions", "<cmd> lua require'nvim-possession'.list()<CR>"),
}
startify.section.bottom_buttons.val = {
	startify.button("q", "❌ quit", "<cmd>qa<CR>"),
	startify.button("h", "✅ checkhealth", "<cmd>checkhealth<CR>"),
	startify.button("p", "🔌 plugins", "<cmd>Lazy<CR>"),
}
startify.section.mru.val = { { type = "padding", val = 0 } }
startify.nvim_web_devicons.enabled = true
alpha.setup(startify.config)
