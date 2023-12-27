local ok, _ = pcall(require, "nvim-treesitter")
if not ok then
	return
end

require("nvim-treesitter.configs").setup({
	highlight = { enable = true, disable = { "markdown" } },
	ensure_installed = {
		"bash",
		"go",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"regex",
		"requirements",
		"rust",
		"toml",
		"yaml",
		"vim",
		"vimdoc",
	},
	matchup = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = { query = "@function.outer", desc = "🌲select around function" },
				["if"] = { query = "@function.inner", desc = "🌲select inside function" },
				["ac"] = { query = "@class.outer", desc = "🌲select around class" },
				["ic"] = { query = "@class.inner", desc = "🌲select inside class" },
				["al"] = { query = "@loop.outer", desc = "🌲select around loop" },
				["il"] = { query = "@loop.inner", desc = "🌲select inside loop" },
				["ab"] = { query = "@block.outer", desc = "🌲select around block" },
				["ib"] = { query = "@block.inner", desc = "🌲select inside block" },
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["g+"] = { query = "@function.outer", desc = "🌲go to next function" },
				["gc+"] = { query = "@class.outer", desc = "🌲go to next class" },
				["gl+"] = { query = "@loop.outer", desc = "🌲go to next loop" },
				["gb+"] = { query = "@block.outer", desc = "🌲go to next block" },
			},
			goto_previous_start = {
				["g-"] = { query = "@function.outer", desc = "🌲go to previous function" },
				["gc-"] = { query = "@class.outer", desc = "🌲go to previous class" },
				["gl-"] = { query = "@loop.outer", desc = "🌲go to previous loop" },
				["gb-"] = { query = "@block.outer", desc = "🌲go to previous block" },
			},
		},
		lsp_interop = {
			enable = true,
			border = "rounded",
			peek_definition_code = {
				["gp"] = { query = "@function.outer", desc = "🌲peek function definition" },
				["gcp"] = { query = "@class.outer", desc = "🌲peek class definition" },
			},
		},
	},
	textsubjects = {
		enable = true,
		prev_selection = ",",
		keymaps = {
			["."] = "textsubjects-smart",
			[";"] = "textsubjects-container-outer",
			[","] = "textsubjects-container-inner",
		},
	},
})

vim.treesitter.language.register("bash", "cheat")
