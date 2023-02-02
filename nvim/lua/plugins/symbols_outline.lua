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
		File = { icon = icons.File, hl = "@text.uri" },
		Module = { icon = "", hl = "@namespace" },
		Namespace = { icon = "", hl = "@namespace" },
		Package = { icon = "", hl = "@namespace" },
		Class = { icon = "𝓒", hl = "@type" },
		Method = { icon = "ƒ", hl = "@method" },
		Property = { icon = "", hl = "@method" },
		Field = { icon = "", hl = "@field" },
		Constructor = { icons.Constructor, hl = "@constructor" },
		Enum = { icon = icons.Enum, hl = "@type" },
		Interface = { icon = icons.Interface, hl = "@type" },
		Function = { icon = icons.Function, hl = "@function" },
		Variable = { icon = icons.Variable, hl = "@constant" },
		Constant = { icon = icons.Constant, hl = "@constant" },
		String = { icon = "𝓐", hl = "@string" },
		Number = { icon = icons.Number, hl = "@number" },
		Boolean = { icon = "⊨", hl = "@boolean" },
		Array = { icon = "", hl = "@constant" },
		Object = { icon = "⦿", hl = "@type" },
		Key = { icon = "", hl = "@type" },
		Null = { icon = "NULL", hl = "@type" },
		EnumMember = { icon = icons.EnumMember, hl = "@field" },
		Struct = { icon = icons.Struct, hl = "@type" },
		Event = { icon = icons.Event, hl = "@type" },
		Operator = { icon = icons.Operator, hl = "@operator" },
		TypeParameter = { icon = icons.TypeParameter, hl = "@parameter" },
	},
})
