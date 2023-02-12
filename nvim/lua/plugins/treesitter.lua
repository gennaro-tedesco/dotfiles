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
					["af"] = { query = "@function.outer", desc = "select around function" },
					["if"] = { query = "@function.inner", desc = "select inside function" },
					["ac"] = { query = "@class.outer", desc = "select around class" },
					["ic"] = { query = "@class.inner", desc = "select inside class" },
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["m+"] = "@function.outer",
				},
				goto_previous_start = {
					["m-"] = "@function.outer",
				},
			},
			lsp_interop = {
				enable = true,
				border = "rounded",
				peek_definition_code = {
					["pd"] = "@function.outer",
				},
			},
		},
	}),
}
