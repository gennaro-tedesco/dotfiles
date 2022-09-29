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
