local ok, symbols = pcall(require, "symbols-outline")
if not ok then
	return
end

symbols.setup({
	highlight_hovered_item = false,
	autofold_depth = 1,
	auto_close = false,
	symbols = {
		File = { icon = Icons.File, hl = "@text.uri" },
		Module = { icon = "", hl = "@namespace" },
		Namespace = { icon = "", hl = "@namespace" },
		Package = { icon = "", hl = "@namespace" },
		Class = { icon = "𝓒", hl = "@type" },
		Method = { icon = "ƒ", hl = "@method" },
		Property = { icon = "", hl = "@method" },
		Field = { icon = "", hl = "@field" },
		Constructor = { Icons.Constructor, hl = "@constructor" },
		Enum = { icon = Icons.Enum, hl = "@type" },
		Interface = { icon = Icons.Interface, hl = "@type" },
		Function = { icon = Icons.Function, hl = "@function" },
		Variable = { icon = Icons.Variable, hl = "@constant" },
		Constant = { icon = Icons.Constant, hl = "@constant" },
		String = { icon = "𝓐", hl = "@string" },
		Number = { icon = Icons.Number, hl = "@number" },
		Boolean = { icon = "⊨", hl = "@boolean" },
		Array = { icon = "", hl = "@constant" },
		Object = { icon = "⦿", hl = "@type" },
		Key = { icon = "", hl = "@type" },
		Null = { icon = "NULL", hl = "@type" },
		EnumMember = { icon = Icons.EnumMember, hl = "@field" },
		Struct = { icon = Icons.Struct, hl = "@type" },
		Event = { icon = Icons.Event, hl = "@type" },
		Operator = { icon = Icons.Operator, hl = "@operator" },
		TypeParameter = { icon = Icons.TypeParameter, hl = "@parameter" },
	},
})
