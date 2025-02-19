nnoremap("<leader>i", function()
	---@module 'snacks'
	Snacks.terminal.open("make -C " .. vim.fs.normalize("~/dotfiles") .. " zsh")
end, { desc = "install zsh" })
