local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
	return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_clear_autocmds({ group = augroup })
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	desc = "null-ls window highlight",
	callback = function()
		vim.api.nvim_set_hl(0, "NullLsInfoBorder", {})
		vim.api.nvim_set_hl(0, "NullLsInfoBorder", { link = "WinSeparator" })
	end,
})

local sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.gofmt,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.isort,
	null_ls.builtins.formatting.black,
	null_ls.builtins.diagnostics.mypy.with({ extra_args = { "--ignore-missing-imports", "--cache-dir=/dev/null" } }),
	null_ls.builtins.formatting.latexindent,
	null_ls.builtins.formatting.prettier.with({ filetypes = { "json", "yaml", "markdown" } }),
	null_ls.builtins.formatting.rustfmt,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.jq,
	null_ls.builtins.hover.printenv,
	null_ls.builtins.code_actions.shellcheck,
	null_ls.builtins.code_actions.gomodifytags,
}

null_ls.setup({
	border = "rounded",
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				desc = "null-ls autoformat on save",
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
	sources = sources,
})
