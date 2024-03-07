local signs_ok, gitsigns = pcall(require, "gitsigns")
if not signs_ok then
	return
end

local icons = require("utils").icons

gitsigns.setup({
	numhl = true,
	signcolumn = false,
	signs = {
		add = { hl = "GitSignsAdd", text = icons.git.Add, numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = {
			hl = "GitSignsChange",
			text = icons.git.Change,
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
		delete = {
			hl = "GitSignsDelete",
			text = icons.git.Delete,
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "_", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		untracked = { hl = "GitSignsAdd", text = icons.git.Add, numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
	},
	preview_config = {
		border = "rounded",
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "++", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "next git hunk" })

		map("n", "--", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "prev git hunk" })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hp", gs.preview_hunk)
		map("n", "<leader>gB", function()
			gs.blame_line({ full = true })
		end, { desc = "git blame" })
	end,
})

local gs_hl = vim.api.nvim_create_augroup("GitSignsHighlight", {})
vim.api.nvim_clear_autocmds({ group = gs_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = gs_hl,
	desc = "redefinition of gitsigns highlight groups",
	callback = function()
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {})
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
	end,
})
