local ok, flash = pcall(require, "flash")
if not ok then
	return
end

flash.setup({
	highlight = { label = { style = "eol" } },
	modes = {
		char = { highlight = { backdrop = false } },
		search = { highlight = { groups = { label = "Todo" } } },
	},
})

vim.keymap.set({ "n", "x", "o" }, "<leader>r", function()
	local win = vim.api.nvim_get_current_win()
	local view = vim.fn.winsaveview()
	require("flash").jump({
		action = function(match, state)
			vim.api.nvim_set_current_win(match.win)
			vim.api.nvim_win_set_cursor(match.win, match.pos)
			require("flash").treesitter()
			vim.schedule(function()
				vim.api.nvim_set_current_win(win)
				vim.fn.winrestview(view)
			end)
		end,
	})
end)
