local ok, symbols = pcall(require, "symbols-outline")
if not ok then
	return
end

local icons = require("utils").icons

symbols.setup({
	highlight_hovered_item = false,
	preview_bg_highlight = "Normal",
	autofold_depth = 1,
	auto_close = false,
	symbols = {
		Array = { icon = icons.kinds.Array, hl = "@constant" },
		Boolean = { icon = icons.kinds.Boolean, hl = "@boolean" },
		Class = { icon = "𝓒", hl = "@type" },
		Constant = { icon = icons.kinds.Constant, hl = "@constant" },
		Constructor = { icons.kinds.Constructor, hl = "@constructor" },
		Enum = { icon = icons.kinds.Enum, hl = "@type" },
		EnumMember = { icon = icons.kinds.EnumMember, hl = "@field" },
		Event = { icon = icons.kinds.Event, hl = "@type" },
		Field = { icon = icons.kinds.Field, hl = "@field" },
		File = { icon = icons.kinds.File, hl = "@text.uri" },
		Function = { icon = icons.kinds.Function, hl = "@function" },
		Interface = { icon = icons.kinds.Interface, hl = "@type" },
		Key = { icon = icons.kinds.Key, hl = "@type" },
		Method = { icon = icons.kinds.Function, hl = "@method" },
		Module = { icon = icons.kinds.Module, hl = "@namespace" },
		Namespace = { icon = icons.kinds.Namespace, hl = "@namespace" },
		Number = { icon = icons.kinds.Number, hl = "@number" },
		Null = { icon = "NULL", hl = "@type" },
		Object = { icon = icons.kinds.Object, hl = "@type" },
		Operator = { icon = icons.kinds.Operator, hl = "@operator" },
		Property = { icon = icons.kinds.Property, hl = "@method" },
		String = { icon = icons.kinds.String, hl = "@string" },
		Struct = { icon = icons.kinds.Struct, hl = "@type" },
		TypeParameter = { icon = icons.kinds.TypeParameter, hl = "@parameter" },
		Variable = { icon = icons.kinds.Variable, hl = "@constant" },
	},
})
