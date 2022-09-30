local opts = { noremap = true, silent = true }
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local null_ls = require("null-ls")

vim.keymap.set("n", "g+", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "g-", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "gl", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.g.diagnostics_visible = true
	local function toggle_diagnostics()
		if vim.g.diagnostics_visible then
			vim.g.diagnostics_visible = false
			vim.diagnostic.disable()
		else
			vim.g.diagnostics_visible = true
			vim.diagnostic.enable()
		end
	end

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, bufopts)
	vim.keymap.set("n", "<leader>l", toggle_diagnostics, bufopts)
	vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, bufopts)
end

local lsp_flags = {
	debounce_text_changes = 150,
}
vim.lsp.set_log_level("debug")

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
		focusable = false,
	},
})

vim.fn.sign_define("DiagnosticSignError", { name = "DiagnosticSignError", text = "✘" })
vim.fn.sign_define("DiagnosticSignWarn", { name = "DiagnosticSignWarn", text = "." })
vim.fn.sign_define("DiagnosticSignHint", { name = "DiagnosticSignHint", text = "⚑" })
vim.fn.sign_define("DiagnosticSignInfo", { name = "DiagnosticSignInfo", text = "i" })

-- null-ls --
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.gofmt,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.isort,
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.prettier.with({ filetypes = { "json", "yaml", "markdown" } }),
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.jq,
	null_ls.builtins.code_actions.shellcheck,
	null_ls.builtins.code_actions.gitsigns,
	null_ls.builtins.hover.printenv,
}

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
	sources = sources,
})
