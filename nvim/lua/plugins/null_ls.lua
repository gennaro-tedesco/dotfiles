local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
	return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.gofmt,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.isort,
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.latexindent,
	null_ls.builtins.formatting.prettier.with({ filetypes = { "json", "yaml", "markdown" } }),
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.jq,
	null_ls.builtins.hover.printenv,
	null_ls.builtins.code_actions.shellcheck,
	null_ls.builtins.code_actions.gitsigns,
}

null_ls.setup({
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
	sources = sources,
})
