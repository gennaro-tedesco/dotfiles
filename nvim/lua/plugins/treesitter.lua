local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	return
end

ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

ts.install({
	"bash",
	"go",
	"hcl",
	"html",
	"json",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"norg",
	"norg_meta",
	"python",
	"regex",
	"requirements",
	"rust",
	"toml",
	"yaml",
	"vim",
	"vimdoc",
	"xml",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.treesitter.language.register("bash", "cheat")
vim.treesitter.language.register("bash", "zsh")
