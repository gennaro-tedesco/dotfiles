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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- configuration of the individual language servers --
require("lspconfig").gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags
})
require("lspconfig").sumneko_lua.setup({
	capabilities = capabilities, on_attach = on_attach, lsp_flags = lsp_flags,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", },
			diagnostics = { globals = { "vim", "P" }, },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), },
			telemetry = { enable = false, },
		},
	},
})
require'lspconfig'.vimls.setup{}

vim.lsp.set_log_level("debug")


-- diagnostics --
vim.diagnostic.config({
  virtual_text = true,
  signs=true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = ''
	})
end

sign({ name = 'DiagnosticSignError', text = '✘' })
sign({ name = 'DiagnosticSignWarn', text = '.' })
sign({ name = 'DiagnosticSignHint', text = '⚑' })
sign({ name = 'DiagnosticSignInfo', text = '' })
