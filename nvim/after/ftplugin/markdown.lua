function _G.md_fold_text()
	local line = vim.fn.getline(vim.v.foldstart)
	local count = vim.v.foldend - vim.v.foldstart + 1
	local icon = "▼"

	line = line:gsub("^%s*%#+%s*", "")

	return {
		{
			string.format("%s … %d%s", line, count, icon),
			"@" .. vim.treesitter.get_captures_at_pos(0, vim.v.foldstart - 1, 1)[1].capture,
		},
	}
end

vim.opt_local.foldtext = "v:lua.md_fold_text()"
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

vim.keymap.set("n", "g0", function()
	local ok, _ = pcall(function()
		vim.cmd.vimgrep("/^#/", "%")
	end)
	if ok then
		vim.cmd.copen()
	else
		vim.notify("no headers found", vim.log.levels.INFO)
	end
end, { buffer = true, desc = "README TOC" })
