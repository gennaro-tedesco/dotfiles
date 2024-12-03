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

---------------
--- keymaps ---
---------------
vim.keymap.set(
	"n",
	"d+",
	vim.diagnostic.goto_next,
	vim.tbl_extend("force", opts, { desc = "✨lsp go to next diagnostic" })
)
vim.keymap.set(
	"n",
	"d-",
	vim.diagnostic.goto_prev,
	vim.tbl_extend("force", opts, { desc = "✨lsp go to prev diagnostic" })
)
vim.keymap.set(
	"n",
	"d/",
	vim.diagnostic.setloclist,
	vim.tbl_extend("force", opts, { desc = "✨lsp send diagnostics to loc list" })
)
vim.keymap.set(
	"n",
	"de",
	vim.diagnostic.open_float,
	vim.tbl_extend("force", opts, { desc = "✨lsp show diagnostic in floating window" })
)

local on_attach = function(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	--- toggle diagnostics
	vim.g.diagnostics_visible = true
	local function toggle_diagnostics()
		if vim.g.diagnostics_visible then
			vim.g.diagnostics_visible = false
			vim.diagnostic.enable(false)
		else
			vim.g.diagnostics_visible = true
			vim.diagnostic.enable(true)
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
	vim.keymap.set(
		"n",
		"<leader>l",
		toggle_diagnostics,
		vim.tbl_extend("force", bufopts, { desc = "✨lsp toggle diagnostics" })
	)
	vim.keymap.set({ "n", "v" }, "<leader>f", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, vim.tbl_extend("force", bufopts, { desc = "✨lsp format" }))
	vim.keymap.set("n", "<leader>dh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ nil }))
	end, vim.tbl_extend("force", bufopts, { desc = "✨lsp toggle inlay hints" }))
	if client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
		vim.keymap.set("n", "<leader>a", function()
			require("fzf-lua").lsp_code_actions()
		end, { desc = "✨lsp code actions" })
	end
end

local lsp_flags = {
	debounce_text_changes = 150,
}
vim.lsp.set_log_level("debug")

--------------------------------------------------------
--- configuration of the individual language servers ---
--------------------------------------------------------

---bashls
lsp.bashls.setup({ filetypes = { "sh" }, on_attach = on_attach })

--- dockerfile ls
lsp.dockerls.setup({ on_attach = on_attach })

---gopls
lsp.gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
	settings = {
		gopls = {
			codelenses = {
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

lsp.marksman.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
})

---sumneko_lua
lsp.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
	settings = {
		Lua = {
			format = { enable = false },
			hint = { enable = true },
			runtime = { version = "LuaJIT" },
			diagnostics = {
				globals = { "describe", "it", "vim", "setup", "teardown" },
				disable = { "missing-fields" },
			},
			workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
			telemetry = { enable = false },
			codeLens = { enable = true },
		},
	},
})

---html vscode-langservers
lsp.cssls.setup({})

lsp.html.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		html = {
			format = {
				templating = true,
				wrapLineLength = 100,
			},
		},
	},
})

---jedi_language_server
lsp.jedi_language_server.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	lsp_flags = lsp_flags,
})

---jsonls
lsp.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

---rust_analyzer
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

---texlab
lsp.texlab.setup({ on_attach = on_attach })

---taplo toml
lsp.taplo.setup({ on_attach = on_attach, capabilities = capabilities })

---typescript
lsp.ts_ls.setup({ on_attach = on_attach, capabilities = capabilities })

---vimls
lsp.vimls.setup({ on_attach = on_attach })

---yamlls
lsp.yamlls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-------------------------------------------
--- diagnostics: linting and formatting ---
-------------------------------------------
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
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

local icons = require("utils").icons
for _, type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
	vim.fn.sign_define(
		"DiagnosticSign" .. type,
		{ name = "DiagnosticSign" .. type, text = icons.diagnostics[type], texthl = "Diagnostic" .. type }
	)
end

require("lspconfig.ui.windows").default_options.border = "rounded"

-------------------
--- lsp logging ---
-------------------
vim.lsp.set_log_level("off")
