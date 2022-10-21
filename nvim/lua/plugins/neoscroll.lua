local ok, neoscroll = pcall(require, "neoscroll")
if not ok then
	return
end

neoscroll.setup({
	mappings = { "<C-u>", "<C-d>", "<C-e>", "zt", "zz", "zb" },
})
