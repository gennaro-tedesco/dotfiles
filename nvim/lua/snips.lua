local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- options
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

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
	lua = {
		s({
			trig = "lf",
			namr = "local function",
		}, {
			t({ "local function " }),
			i(1, "fun name"),
			t({ "(" }),
			i(2, "fun args"),
			t({ ")" }),
			t({ "", "	" }),
			i(3, "fun body"),
			t({ "", "end" }),
		}),
	},
})
