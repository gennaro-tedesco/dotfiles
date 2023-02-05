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
	}),
}
