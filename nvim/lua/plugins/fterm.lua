local ok, fterm = pcall(require, "FTerm")
if not ok then
	return
end

fterm.setup({
	border = "rounded",
	dimensions = {
		height = 0.85,
		width = 0.9,
	},
})

vim.keymap.set("n", "<F2>", '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set("t", "<F2>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
