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
local snips = {
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
		s({
			trig = "mod",
			namr = "local module",
			dscr = "return local module M",
		}, {
			t({ "local M = {}" }),
			t({ "", "", "" }),
			i(0),
			t({ "", "" }),
			t({ "", "return M" }),
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

	vim = {
		s({
			trig = "plug",
			namr = "include plugin",
		}, {
			t("Plug '"),
			f(function(_, snip)
				return snip.env.TM_SELECTED_TEXT[1] or {}
			end, {}),
			t("'"),
			i(0),
		}),
	},

	sh = {
		s({
			trig = "shebang",
			namr = "preferred shebang",
		}, {
			t("#!/bin/sh"),
			i(0),
		}),
	},

	python = {
		s({
			trig = "test",
			namr = "template unit test",
		}, {
			t("import unittest"),
			t({ "", "", "", "" }),
			t("class "),
			i(1, "TestCaseName"),
			t("(unittest.TestCase):"),
			t({ "", "" }),
			t("    def setUp(self):"),
			t({ "", "" }),
			t("        return None"),
			t({ "", "", "" }),
			t("    def "),
			i(2, "test_function_name"),
			t("(self):"),
			t({ "", "" }),
			t("        return None"),
			t({ "", "", "", "" }),
			t('if __name__ == "__main__":'),
			t({ "", "" }),
			t("    unittest.main()"),
		}),
	},
}

-- add snips to engine
ls.add_snippets(nil, {
	lua = snips.lua,
	markdown = snips.markdown,
	python = snips.python,
	vim = snips.vim,
	sh = snips.sh,
})
