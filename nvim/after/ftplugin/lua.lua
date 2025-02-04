vim.opt_local.suffixesadd:prepend(".lua")
vim.opt_local.suffixesadd:prepend("init.lua")
vim.opt_local.path:prepend(vim.fn.stdpath("config") .. "/lua")

nnoremap("<leader>i", function()
	Snacks.terminal.open("make nvim")
end, { desc = "install nvim dotfiles" })
