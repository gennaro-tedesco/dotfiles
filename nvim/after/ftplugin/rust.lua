vim.cmd.compiler("cargo")

vim.api.nvim_create_user_command("Build", function()
	vim.cmd.make({ args = { "build" }, mods = { silent = true } })
end, {})
