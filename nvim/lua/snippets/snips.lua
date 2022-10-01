local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local lua = {
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
}

local markdown = {
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

local vim = {
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

return { lua = lua, markdown = markdown, vim = vim }
