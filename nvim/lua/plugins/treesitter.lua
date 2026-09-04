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

vim.treesitter.language.register("bash", "cheat")
vim.treesitter.language.register("bash", "zsh")

-- ts.install-managed languages register their query directly via
-- vim.treesitter.query.set(), so after/queries/<lang>/<name>.scm isn't
-- consulted for them. Merge such a file in by hand when present.
local function extend_query(lang, query_name)
	local custom = vim.api.nvim_get_runtime_file(string.format("after/queries/%s/%s.scm", lang, query_name), false)[1]
	if not custom then
		return
	end

	local lines = {}
	for _, file in ipairs(vim.treesitter.query.get_files(lang, query_name)) do
		vim.list_extend(lines, vim.fn.readfile(file))
	end
	vim.list_extend(lines, vim.fn.readfile(custom))

	vim.treesitter.query.set(lang, query_name, table.concat(lines, "\n"))
end

extend_query("yaml", "injections")
