local ok, flash = pcall(require, "flash")
if not ok then
	return
end

flash.setup({
	label = { min_pattern_length = 2, style = "eol" },
	highlight = { groups = { backdrop = "SignColumn" } },
	modes = {
		char = { highlight = { backdrop = false }, search = { wrap = true } },
		search = { highlight = { groups = { label = "Todo" } } },
		treesitter = {
			label = {
				before = true,
				after = true,
				style = "overlay",
				rainbow = { enabled = true, shade = 5 },
			},
		},
	},
})

vim.keymap.set({ "n", "x", "o" }, "<leader>t", function()
	local win = vim.api.nvim_get_current_win()
	local view = vim.fn.winsaveview()
	require("flash").jump({
		action = function(match, state)
			state:hide()
			vim.api.nvim_set_current_win(match.win)
			vim.api.nvim_win_set_cursor(match.win, match.pos)
			require("flash").treesitter()
			vim.schedule(function()
				vim.api.nvim_set_current_win(win)
				vim.fn.winrestview(view)
			end)
		end,
		highlight = { backdrop = false },
	})
end, { desc = "flash treesitter operator" })
