vim.opt_local.suffixesadd:prepend(".lua")
vim.opt_local.suffixesadd:prepend("init.lua")
vim.opt_local.path:prepend(vim.fn.stdpath("config") .. "/lua")

local function install()
	local make_cmd = vim.system({ "make", "-C", vim.fs.normalize("~/dotfiles"), "nvim" }, { text = true }):wait()
	if make_cmd.code ~= 0 then
		vim.notify(
			make_cmd.stderr,
			vim.log.levels.ERROR,
			{ ft = "bash", style = "compact", title = "install nvim config", id = "nvim" }
		)
		return
	end
	vim.notify(
		make_cmd.stdout:gsub("\n[^\n]*$", ""),
		vim.log.levels.INFO,
		{ ft = "bash", style = "compact", title = "install nvim config", id = "nvim" }
	)
end
nnoremap("<leader>i", install, { desc = "install nvim dotfiles" })
