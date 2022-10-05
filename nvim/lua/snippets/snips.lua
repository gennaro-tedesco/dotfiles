local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- must include filetype snippets in snip_config.lua
-- ls.add_snippets({ ft = snips.ft})
local M = {}

M.lua = {
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
}

M.markdown = {
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
}

M.vim = {
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
}

M.sh = {
	s({
		trig = "shebang",
		namr = "preferred shebang",
	}, {
		t("#!/bin/sh"),
		i(0),
	}),
}

M.python = {
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
}

return M
