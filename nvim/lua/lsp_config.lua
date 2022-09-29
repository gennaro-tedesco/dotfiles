local opts = { noremap = true, silent = true }
vim.keymap.set("n", "g+", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "g-", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "gl", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)
	vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
end

local lsp_flags = {
	debounce_text_changes = 150,
}
vim.lsp.set_log_level("debug")

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- configuration of the individual language servers --
require("lspconfig").gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
})
require("lspconfig").sumneko_lua.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "P" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})
require("lspconfig").jedi_language_server.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
})
require("lspconfig").vimls.setup({ on_attach = on_attach })
require("lspconfig").bashls.setup({ on_attach = on_attach })
require("lspconfig").jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- diagnostics: linting and formatting --
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.fn.sign_define("DiagnosticSignError", { name = "DiagnosticSignError", text = "✘" })
vim.fn.sign_define("DiagnosticSignWarn", { name = "DiagnosticSignWarn", text = "." })
vim.fn.sign_define("DiagnosticSignHint", { name = "DiagnosticSignHint", text = "⚑" })
vim.fn.sign_define("DiagnosticSignInfo", { name = "DiagnosticSignInfo", text = "" })

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
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
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.gofmt,
		require("null-ls").builtins.formatting.goimports,
		require("null-ls").builtins.formatting.isort,
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.shfmt,
		require("null-ls").builtins.formatting.jq,
	},
})
