local ok, ls = pcall(require, "luasnip")
if not ok then
	return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require("luasnip.util.types")

-- options
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	store_selection_keys = "<c-s>",
	ext_opts = {
		[types.insertNode] = {
			visited = { hl_group = "Comment" },
			unvisited = { hl_group = "Comment" },
		},
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "Special" } },
			},
		},
	},
})

-- commands
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true, desc = "🚀snip jump to next placeholder" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.expand_or_jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true, desc = "🚀snip jump to prev placeholder" })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { desc = "🚀snip next choice" })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end, { desc = "🚀snip prev choice" })

-- snippets
local snips = {
	go = {
		s(
			{ trig = "err", name = "error check" },
			fmt(
				[[
				if {} != nil {{
					{}
				}}
				]],
				{ i(1, "err"), i(2, "body") }
			)
		),
	},
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
			{ trig = "aucmd", name = "create lua autocommand" },
			fmt(
				[[
				local {} = vim.api.nvim_create_augroup("{}", {{}})
				vim.api.nvim_clear_autocmds({{ group = {} }})
				vim.api.nvim_create_autocmd("{}", {{
					group = {},
					callback = function()
						{}
					end,
				}})
				]],
				{
					i(1, "name"),
					i(2, "augroup_name"),
					f(function(name)
						return name[1]
					end, { 1 }),
					i(3, "vim event"),
					f(function(name)
						return name[1]
					end, { 1 }),
					i(0, "command"),
				}
			)
		),
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
		s(
			{ trig = "plug", name = "new plugin" },
			fmt(
				[[
				{{
					"{}",
					opts = {},
				}},
				]],
				{ i(1, "plugin"), i(2, "opts") }
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
				trig = "main",
				name = "",
			},
			fmt(
				[[
				if __name__ == "__main__":
				    {}
				]],
				{ i(0) }
			)
		),
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
		}, fmt([[${{{}}}]], i(1, "var"))),
	},
	tex = {
		s(
			{ trig = "env", name = "latex environment" },
			fmt(
				[[
				\begin{{{}}}
					{}
				\end{{{}}}
				]],
				{
					i(1, "env"),
					i(0, "body"),
					f(function(env)
						return env[1]
					end, { 1 }),
				}
			)
		),
	},
	txt = {
		s({
			trig = "day",
			name = "choose day of the week",
		}, c(1, { t("Monday"), t("Tuesday"), t("Wednesday"), t("Thursday"), t("Friday"), t("Saturday"), t("Sunday") })),
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
	go = snips.go,
	lua = snips.lua,
	markdown = snips.markdown,
	python = snips.python,
	sh = snips.sh,
	tex = snips.tex,
	txt = snips.txt,
	vim = snips.vim,
	zsh = snips.zsh,
})

local list_snips = function()
	local ft_list = require("luasnip").available()[vim.o.filetype]
	local ft_snips = {}
	for _, item in pairs(ft_list) do
		ft_snips[item.trigger] = item.name
	end
	P(ft_snips)
end

vim.api.nvim_create_user_command("SnipList", list_snips, {})
require("plugins.snip_ui")
