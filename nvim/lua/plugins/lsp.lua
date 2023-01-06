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

vim.keymap.set(
	"n",
	"g+",
	vim.diagnostic.goto_next,
	vim.tbl_extend("force", opts, { desc = "✨lsp go to next diagnostic" })
)
vim.keymap.set(
	"n",
	"g-",
	vim.diagnostic.goto_prev,
	vim.tbl_extend("force", opts, { desc = "✨lsp go to prev diagnostic" })
)
vim.keymap.set(
	"n",
	"g/",
	vim.diagnostic.setloclist,
	vim.tbl_extend("force", opts, { desc = "✨lsp send diagnostics to loc list" })
)
vim.keymap.set(
	"n",
	"ge",
	vim.diagnostic.open_float,
	vim.tbl_extend("force", opts, { desc = "✨lsp show diagnostic in floating window" })
)

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
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "✨lsp hover for docs" }))
	vim.keymap.set(
		"n",
		"gD",
		vim.lsp.buf.declaration,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp go to declaration" })
	)
	vim.keymap.set(
		"n",
		"gd",
		vim.lsp.buf.definition,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp go to definition" })
	)
	vim.keymap.set(
		"n",
		"gt",
		vim.lsp.buf.type_definition,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp go to type definition" })
	)
	vim.keymap.set(
		"n",
		"gi",
		vim.lsp.buf.implementation,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp go to implementation" })
	)
	vim.keymap.set("n", "rn", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true })
	vim.keymap.set(
		"n",
		"gr",
		vim.lsp.buf.references,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp go to references" })
	)
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, vim.tbl_extend("force", bufopts, { desc = "✨lsp format" }))
	vim.keymap.set(
		"n",
		"<leader>l",
		toggle_diagnostics,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp toggle diagnostics" })
	)
	vim.keymap.set(
		"n",
		"<leader>a",
		vim.lsp.buf.code_action,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp code action" })
	)
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
			workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
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
lsp.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
		},
	},
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
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
