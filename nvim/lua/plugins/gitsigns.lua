local signs_ok, gitsigns = pcall(require, "gitsigns")
if not signs_ok then
	return
end

local icons = require("utils").icons

gitsigns.setup({
	numhl = true,
	signcolumn = false,
	signs = {
		add = { text = icons.git.Add },
		change = { text = icons.git.Change },
		delete = { text = icons.git.Delete },
		topdelete = { text = "‾" },
		changedelete = { text = "_" },
		untracked = { text = icons.git.Add },
	},
	preview_config = {
		border = "rounded",
	},
	current_line_blame_formatter = "\t<author>: <author_time:%Y-%m-%d> - <abbrev_sha>",
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 300,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		--- navigation
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

		--- actions
		map("n", "<leader>hs", gitsigns.stage_hunk)
		map("n", "<leader>hr", gitsigns.reset_hunk)
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("n", "<leader>hu", gitsigns.undo_stage_hunk)
		map("n", "<leader>hp", gitsigns.preview_hunk)

		--- git blame
		map("n", "<leader>hb", function()
			gitsigns.toggle_current_line_blame()
		end, { desc = "toggle git blame inline" })
		vim.keymap.set("n", "<leader>gb", function()
			local blame_buf = nil
			for _, buf_nr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[buf_nr].filetype == "gitsigns-blame" then
					blame_buf = buf_nr
					break
				end
			end
			if blame_buf ~= nil then
				vim.cmd.bd(blame_buf)
			else
				local is_git = vim.system(
					{ "git", "ls-files", "--error-unmatch", vim.api.nvim_buf_get_name(0) },
					{ text = true }
				)
					:wait()
				if is_git.code ~= 1 then
					gitsigns.blame()
				else
					print("file not tracked")
				end
			end
		end, { desc = "git blame side" })
	end,
})

local gs_hl = vim.api.nvim_create_augroup("GitSignsHighlight", {})
vim.api.nvim_clear_autocmds({ group = gs_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = gs_hl,
	desc = "redefinition of gitsigns highlight groups",
	callback = function()
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
		vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
		vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChangeLn" })
		vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeNr" })
		vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
		vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsDeleteLn" })
		vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDeleteNr" })
		vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "GitSignsAdd" })
		vim.api.nvim_set_hl(0, "GitSignsUntrackedLn", { link = "GitSignsAddLn" })
		vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsAddNr" })
	end,
})
