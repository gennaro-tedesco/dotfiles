vim.cmd.compiler("go")

vim.api.nvim_create_user_command("Build", function()
	vim.cmd.make({ args = { "." }, mods = { silent = true } })
end, {})

vim.api.nvim_create_user_command("Run", function()
	require("FTerm").run({ "go", "run", "." })
end, {})

vim.api.nvim_create_user_command("Tidy", function()
	vim.cmd.LspStop()
	vim.system({ "go", "mod", "tidy", "-v" }, { text = true })
	vim.cmd.write()
	vim.cmd.LspStart()
end, {})
