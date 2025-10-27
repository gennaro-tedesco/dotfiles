vim.wo.conceallevel = 2
vim.keymap.set("n", "g0", "<cmd>Neorg toc qflist<CR>", { buffer = true, desc = "neorg open toc" })
vim.keymap.set("n", "gf", "<Plug>(neorg.esupports.hop.hop-link)", { buffer = true, desc = "neorg follow link" })
vim.keymap.set(
	"n",
	"<C-Space>",
	"<Plug>(neorg.qol.todo-items.todo.task-cycle)",
	{ buffer = true, desc = "neorg toggle tasks cycle" }
)

function _G.norg_fold_text()
	local line = vim.fn.getline(vim.v.foldstart)
	local count = vim.v.foldend - vim.v.foldstart + 1
	local icon = "▼"

	local level = line:match("^%s*(%*+)")
	local indent = level and string.rep(" ", #level) or " "
	line = line:gsub("^%s*%*+%s*", "")

	return {
		{
			string.format("%s %s … %d%s", indent, line, count, icon),
			"@" .. vim.treesitter.get_captures_at_pos(0, vim.v.foldstart - 1, 1)[1].capture,
		},
	}
end

vim.opt_local.foldtext = "v:lua.norg_fold_text()"
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

vim.api.nvim_create_autocmd("BufWritePost", {
	buffer = 0,
	callback = function()
		vim.cmd.edit()
	end,
})
