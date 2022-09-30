local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- options
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	store_selection_keys = "<c-s>",
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
			i(0),
		}),
	},
	markdown = {
		s({
			trig = "link",
			namr = "markdown_link",
			dscr = "Create markdown link [txt](url)",
		}, {
			t("["),
			i(1),
			t("]("),
			f(function(_, snip)
				return snip.env.TM_SELECTED_TEXT[1] or {}
			end, {}),
			t(")"),
			i(0),
		}),
	},
})
