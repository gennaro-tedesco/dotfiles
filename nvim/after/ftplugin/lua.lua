vim.opt_local.suffixesadd:prepend(".lua")
vim.opt_local.suffixesadd:prepend("init.lua")
vim.opt_local.path:prepend(vim.fn.stdpath("config") .. "/lua")

nnoremap("<leader>i", function()
	---@module 'snacks'
	if vim.api.nvim_buf_get_name(0):match("wezterm") ~= nil then
		Snacks.terminal.open("make -C " .. vim.fs.normalize("~/dotfiles") .. " wezterm")
	elseif vim.api.nvim_buf_get_name(0):match("yazi") ~= nil then
		Snacks.terminal.open("make -C " .. vim.fs.normalize("~/dotfiles") .. " yazi")
	else
		Snacks.terminal.open("make -C " .. vim.fs.normalize("~/dotfiles") .. " nvim")
	end
end, { desc = "make dotfiles target" })
