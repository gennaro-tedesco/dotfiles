vim.cmd.compiler("cargo")

vim.api.nvim_create_user_command("Build", function()
	vim.cmd.make({ args = { "build" }, mods = { silent = true } })
end, {})

vim.api.nvim_create_user_command("Run", function()
	require("FTerm").run({ "cargo", "run" })
end, {})
