vim.opt_local.suffixesadd:prepend(".lua")
vim.opt_local.suffixesadd:prepend("init.lua")
vim.opt_local.path:prepend(vim.fn.stdpath("config") .. "/lua")

nnoremap("<leader>i", function()
	---@module 'snacks'
	Snacks.terminal.open("make -C " .. vim.fs.normalize("~/dotfiles") .. " nvim")
end, { desc = "install nvim dotfiles" })
