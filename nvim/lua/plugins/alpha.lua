local ok, alpha = pcall(require, "alpha")
if not ok then
	return
end

local startify = require("alpha.themes.startify")
startify.section.header.val = { "welcome back, and a fine day it is!" }
startify.section.top_buttons.val = {
	startify.button("e", " New file", ":ene <BAR> startinsert <CR>"),
	startify.button("t", " Todo", ":e<space>~/.todo<CR>"),
	startify.button("s", " Sessions", "<cmd> lua require('plugins.sessions').list()<CR>"),
}
startify.section.bottom_buttons.val = {
	startify.button("q", "✘ Quit NVIM", ":qa<CR>"),
	startify.button("h", "✔ checkhealth", ":checkhealth<CR>"),
}
startify.section.mru.val = { { type = "padding", val = 0 } }
startify.nvim_web_devicons.enabled = false
alpha.setup(startify.config)
