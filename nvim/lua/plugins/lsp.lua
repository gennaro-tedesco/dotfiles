local lsp_ok, lsp = pcall(require, "lspconfig")
if not lsp_ok then
	return
end

local cmq_ok, _ = pcall(require, "cmp_nvim_lsp")
if not cmq_ok then
	return
end

local opts = { noremap = true, silent = true }
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
	vim.keymap.set("n", "rn", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, bufopts)
	vim.keymap.set("n", "<leader>l", toggle_diagnostics, bufopts)
	vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, bufopts)
end

local lsp_flags = {
	debounce_text_changes = 150,
}
vim.lsp.set_log_level("debug")

-- configuration of the individual language servers --
lsp.gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
})
lsp.sumneko_lua.setup({
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
lsp.jedi_language_server.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
})
lsp.vimls.setup({ on_attach = on_attach })
lsp.bashls.setup({ on_attach = on_attach })
lsp.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp.texlab.setup({ on_attach = on_attach })

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
vim.fn.sign_define("DiagnosticSignWarn", { name = "DiagnosticSignWarn", text = "" })
vim.fn.sign_define("DiagnosticSignHint", { name = "DiagnosticSignHint", text = "i" })
vim.fn.sign_define("DiagnosticSignInfo", { name = "DiagnosticSignInfo", text = "i" })
