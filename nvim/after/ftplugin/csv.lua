vim.keymap.set("n", "<Right>", "f,l", { buffer = 0, desc = "csv go to next field" })
vim.keymap.set("n", "<Left>", "F,b", { buffer = 0, desc = "csv go to previous field" })

vim.api.nvim_create_user_command("View", function()
	require("FTerm").run({ "vd", vim.api.nvim_buf_get_name(0) })
end, {})
