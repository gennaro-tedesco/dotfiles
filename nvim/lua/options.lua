-- treesitter
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	ensure_installed = { "go", "python", "json", "lua", "bash", "yaml" },
})

-- neoscroll
require("neoscroll").setup()

-- quickfix windows
require("bqf").setup({ func_map = { openc = "<CR>" } })
require("pqf").setup({
	signs = { error = "✘", warning = "W", info = "I", hint = "H" },
})
require("nvim-jqx.config").use_quickfix = false

-- git-conflict
require("git-conflict").setup({
	default_mappings = true,
	highlights = { incoming = "DiffText", current = "DiffAdd" },
})
vim.keymap.set("n", "c+", "<Plug>(git-conflict-next-conflict)")
vim.keymap.set("n", "c-", "<Plug>(git-conflict-prev-conflict)")
vim.keymap.set("n", "cq", ":GitConflictListQf<CR>")

-- git-signs
require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "_", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
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
		end, { expr = true })

		map("n", "--", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end)
	end,
})

-- marks
require("marks").setup({
	mappings = {
		set_next = "mm",
		next = "mn",
		prev = "mp",
		preview = false,
	},
})

vim.keymap.set("n", "m/", ":MarksListAll<CR>")

-- notify
require("notify").setup({
	timeout = 5000,
	stages = "slide",
	render = "minimal",
})

-- lastplace
require("nvim-lastplace").setup({
	lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
	lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
	lastplace_open_folds = true,
})

-- comments
require("Comment").setup()
