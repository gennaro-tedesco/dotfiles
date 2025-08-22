nnoremap("<leader>i", function()
	---@module 'snacks'
	if vim.api.nvim_buf_get_name(0):match("yazi") ~= nil then
		Snacks.terminal.open("make -C " .. vim.fs.normalize("~/dotfiles") .. " yazi")
	end
end, { desc = "install yazi dotfiles" })
