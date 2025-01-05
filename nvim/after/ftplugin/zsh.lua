local function install()
	local make_cmd = vim.system({ "make", "-C", vim.fs.normalize("~/dotfiles"), "zsh" }, { text = true }):wait()
	if make_cmd.code ~= 0 then
		vim.notify(
			make_cmd.stderr,
			vim.log.levels.ERROR,
			{ ft = "bash", style = "compact", title = "install zsh shell config", id = "zsh" }
		)
		return
	end
	vim.notify(
		make_cmd.stdout:gsub("\n[^\n]*$", ""),
		vim.log.levels.INFO,
		{ ft = "bash", style = "compact", title = "install zsh shell config", id = "zsh" }
	)
end
nnoremap("<leader>i", install, { desc = "install nvim dotfiles" })
