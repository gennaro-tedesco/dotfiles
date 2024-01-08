vim.keymap.set("n", "q", function()
	vim.cmd.quit()
end, { buffer = 0, desc = "close git commit view" })
