local ok, symbols = pcall(require, "symbols-outline")
if not ok then
	return
end

symbols.setup({
	highlight_hovered_item = false,
	preview_bg_highlight = "Normal",
	autofold_depth = 1,
	auto_close = false,
	symbols = {
		Array = { icon = icons.Array, hl = "@constant" },
		Boolean = { icon = icons.Boolean, hl = "@boolean" },
		Class = { icon = "𝓒", hl = "@type" },
		Constant = { icon = icons.Constant, hl = "@constant" },
		Constructor = { icons.Constructor, hl = "@constructor" },
		Enum = { icon = icons.Enum, hl = "@type" },
		EnumMember = { icon = icons.EnumMember, hl = "@field" },
		Event = { icon = icons.Event, hl = "@type" },
		Field = { icon = icons.Field, hl = "@field" },
		File = { icon = icons.File, hl = "@text.uri" },
		Function = { icon = icons.Function, hl = "@function" },
		Interface = { icon = icons.Interface, hl = "@type" },
		Key = { icon = icons.Key, hl = "@type" },
		Method = { icon = icons.Function, hl = "@method" },
		Module = { icon = icons.Module, hl = "@namespace" },
		Namespace = { icon = icons.Namespace, hl = "@namespace" },
		Number = { icon = icons.Number, hl = "@number" },
		Null = { icon = "NULL", hl = "@type" },
		Object = { icon = icons.Object, hl = "@type" },
		Operator = { icon = icons.Operator, hl = "@operator" },
		Property = { icon = icons.Property, hl = "@method" },
		String = { icon = icons.String, hl = "@string" },
		Struct = { icon = icons.Struct, hl = "@type" },
		TypeParameter = { icon = icons.TypeParameter, hl = "@parameter" },
		Variable = { icon = icons.Variable, hl = "@constant" },
	},
})
