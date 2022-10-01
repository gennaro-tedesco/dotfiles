local ls = require("luasnip")
local snips = require("snippets.snips")

-- options
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	store_selection_keys = "<c-s>",
})

-- commands
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.expand_or_jumpable(-1) then
		ls.expand_or_jump(-1)
	end
end, { silent = true })

-- snippets
ls.add_snippets(nil, {
	lua = snips.lua,
	markdown = snips.markdown,
	vim = snips.vim,
})
