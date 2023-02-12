return {
	require("nvim-treesitter.configs").setup({
		highlight = { enable = true, disable = { "markdown" } },
		ensure_installed = {
			"bash",
			"help",
			"go",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"regex",
			"rust",
			"yaml",
			"vim",
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
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["g+"] = { query = "@function.outer", desc = "🌲go to next function" },
					["gc+"] = { query = "@class.outer", desc = "🌲go to next class" },
				},
				goto_previous_start = {
					["g-"] = { query = "@function.outer", desc = "🌲go to previous function" },
					["gc-"] = { query = "@class.outer", desc = "🌲go to previous class" },
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
	}),
}
