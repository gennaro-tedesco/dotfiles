local ok, fterm = pcall(require, "FTerm")
if not ok then
	return
end

fterm.setup({ border = "rounded", dimensions = { height = 0.85, width = 0.9 } })

vim.keymap.set("n", "<F2>", '<cmd>lua require("FTerm").toggle()<CR>')
vim.keymap.set("t", "<F2>", '<C-\\><C-n><cmd>lua require("FTerm").toggle()<CR>')

local view_md = function()
	local buf = vim.api.nvim_buf_get_name(0)
	local ft = vim.filetype.match({ filename = buf })
	local md = fterm:new({
		cmd = "glow -s ~/.config/glowconfig/customglow.json -p " .. buf,
	})
	if ft == "markdown" then
		md:toggle()
	end
end

vim.keymap.set("n", "<F3>", view_md, { desc = "render markdown file in toggled terminal" })
