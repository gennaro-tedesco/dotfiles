local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	return
end

ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

ts.install({
	"bash",
	"dart",
	"go",
	"hcl",
	"html",
	"json",
	"lua",
	"javascript",
	"kotlin",
	"make",
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
	"xml",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

local syntax_only_ft = { "helm" }

vim.api.nvim_create_autocmd("FileType", {
	pattern = syntax_only_ft,
	callback = function(ev)
		vim.schedule(function()
			vim.treesitter.stop(ev.buf)
		end)
	end,
})

vim.treesitter.language.register("bash", "cheat")
vim.treesitter.language.register("bash", "zsh")
