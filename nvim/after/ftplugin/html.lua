vim.fn.setreg("w", "da>@w")
vim.api.nvim_create_user_command("RemoveTags", "norm @w", { desc = "remove all tags" })
