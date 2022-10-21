local ok, symbols = pcall(require, "symbols-outline")
if not ok then
	return
end

symbols.setup({
	highlight_hovered_item = false,
	autofold_depth = 1,
	symbols = {
		Function = { icon = Icons.Function },
	},
})
