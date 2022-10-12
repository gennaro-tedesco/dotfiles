local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

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
		s({ trig = "req", dscr = "local require" }, fmt("local {} = require('{}')", { i(1, "name"), i(2, "module") })),
		s(
			{ trig = "lf", dscr = "local function" },
			fmt(
				[[
				local function {}({})
					{}
				end
				]],
				{ i(1, "name"), i(2, "args"), i(3, "body") }
			)
		),
		s(
			{ trig = "mod", dscr = "local module M" },
			fmt(
				[[
				local M = {{}}

				{}

				return M
				]],
				i(0)
			)
		),
	},
	markdown = {
		s(
			{
				trig = "link",
				dscr = "Create markdown link [txt](url)",
			},
			fmt(
				"[{}]({})",
				{ i(1, "description"), f(function(_, snip)
					return snip.env.TM_SELECTED_TEXT[1] or {}
				end, {}) }
			)
		),
	},
	python = {
		s(
			{
				trig = "test",
				dscr = "template unit test",
			},
			fmt(
				[[
				import unittest

				class {}(unittest.TestCase):

					def setUp(self):
						return None

					def test_{}():
						self.assertTrue(True)

				if __name__ == '__main__':
					unittest.main()
				]],
				{ i(1, "className"), i(2, "function_name") }
			)
		),
		s({
			trig = "csv",
			dscr = "save df to csv",
		}, {
			f(function(_, snip)
				return snip.env.TM_SELECTED_TEXT[1] or {}
			end, {}),
			t({ ".to_csv('" }),
			f(function(_, snip)
				return snip.env.TM_SELECTED_TEXT[1] or {}
			end, {}),
			t({ ".csv', index=False)" }),
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
		s({
			trig = "var",
			namr = "variable indicator",
		}, fmt('"${}"', i(1, "var"))),
	},
	vim = {
		s(
			{
				trig = "plug",
				namr = "include plugin",
			},
			fmt(
				"Plug '{}'",
				f(function(_, snip)
					return snip.env.TM_SELECTED_TEXT[1] or {}
				end, {})
			)
		),
	},
	zsh = {
		s({
			trig = "var",
			namr = "variable indicator",
		}, fmt('"${}"', i(1, "var"))),
	},
}

-- add snips to engine
ls.add_snippets(nil, {
	lua = snips.lua,
	markdown = snips.markdown,
	python = snips.python,
	sh = snips.sh,
	vim = snips.vim,
	zsh = snips.zsh,
})
