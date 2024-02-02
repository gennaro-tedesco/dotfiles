local function adjust_height(min_height, max_height)
	local height = math.max(math.min(vim.fn.line("$"), max_height), min_height)
	vim.cmd(height .. "wincmd_")
end

adjust_height(3, 10)

vim.opt_local.cursorline = true
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.hlsearch = false

vim.api.nvim_set_hl(0, "Search", {})
vim.api.nvim_set_hl(0, "QuickFixLine", {})
