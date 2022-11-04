local ok, ls = pcall(require, "luasnip")
if not ok then
	return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require("luasnip.util.types")

-- options
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	store_selection_keys = "<c-s>",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "InsertMode" } },
			},
		},
	},
})

-- commands
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.expand_or_jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

vim.keymap.set({ "i", "s" }, "<C-h>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end)

-- snippets
local snips = {
	lua = {
		s(
			{ trig = "pcall", name = "protected call" },
			fmt(
				[[
				local ok, {} = pcall(require, '{}')
				if not ok then return end
				]],
				{ i(1, "name"), i(2, "module") }
			)
		),
		s({ trig = "req", name = "local require" }, fmt("local {} = require('{}')", { i(1, "name"), i(2, "module") })),
		s(
			{ trig = "lf", name = "local function" },
			fmt(
				[[
				local function {}({})
					{}
				end
				]],
				{ i(1, "name"), i(2, "args"), i(0) }
			)
		),
		s(
			{ trig = "mod", name = "local module M" },
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
				name = "Create markdown link [txt](url)",
			},
			fmt(
				"[{}]({})",
				{ i(1, "description"), f(function(_, snip)
					return snip.env.TM_SELECTED_TEXT[1] or {}
				end, {}) }
			)
		),
		s(
			{
				trig = "lang",
				name = "code block markdown language",
			},
			fmt(
				[[
				```{}

				{}
				```
				]],
				{ i(1, "language"), i(2, "body") }
			)
		),
	},
	python = {
		s(
			{
				trig = "test",
				name = "template unit test",
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
			name = "save df to csv",
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
			name = "preferred shebang",
		}, {
			t("#!/bin/sh"),
			i(0),
		}),
		s({
			trig = "var",
			name = "variable indicator",
		}, fmt('"${}"', i(1, "var"))),
	},
	vim = {
		s(
			{
				trig = "plug",
				name = "include plugin",
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
			name = "variable indicator",
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
