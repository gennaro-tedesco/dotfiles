local ok, _ = pcall(require, "nvim-treesitter")
if not ok then
	return
end

require("nvim-treesitter.configs").setup({
	highlight = { enable = true, disable = { "markdown" } },
	ensure_installed = { "bash", "go", "json", "lua", "markdown", "markdown_inline", "python", "regex", "yaml", "vim" },
})
