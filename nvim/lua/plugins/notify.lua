local ok, notify = pcall(require, "notify")
if not ok then
	return
end

local notify_hl = vim.api.nvim_create_augroup("NotifyHighlights", {})
vim.api.nvim_clear_autocmds({ group = notify_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = notify_hl,
	callback = function()
		vim.api.nvim_set_hl(0, "NotifyINFOIcon", {})
		vim.api.nvim_set_hl(0, "NotifyINFOIcon", { link = "Character" })
	end,
})

notify.setup({
	timeout = 5000,
	render = "minimal",
	stages = "static",
})
