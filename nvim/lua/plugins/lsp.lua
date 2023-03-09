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
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	--- toggle diagnostics
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

	--- autocmd to show diagnostics on CursorHold
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		desc = "✨lsp show diagnostics on CursorHold",
		callback = function()
			local hover_opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "always",
				prefix = " ",
			}
			vim.diagnostic.open_float(nil, hover_opts)
		end,
	})

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
		"<cmd>CodeActionMenu<CR>",
		vim.tbl_extend("force", bufopts, { desc = "✨lsp code action" })
	)
end

local lsp_flags = {
	debounce_text_changes = 150,
}
vim.lsp.set_log_level("debug")

--------------------------------------------------------
--- configuration of the individual language servers ---
--------------------------------------------------------

---bashls
lsp.bashls.setup({ on_attach = on_attach })

---gopls
lsp.gopls.setup({
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
			format = {
				enable = false,
			},
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "describe", "it", "vim", "setup", "teardown" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
			telemetry = { enable = false },
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

---vimls
lsp.vimls.setup({ on_attach = on_attach })

---yamlls
lsp.yamlls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://json.schemastore.org/pre-commit-config.json"] = "/.pre-commit-config.*",
				["https://raw.githubusercontent.com/iterative/dvcyaml-schema/master/schema.json"] = "dvc.yaml",
				["https://json.schemastore.org/swagger-2.0.json"] = "swagger.yaml",
			},
		},
	},
})

-------------------------------------------
--- diagnostics: linting and formatting ---
-------------------------------------------
vim.diagnostic.config({
	virtual_text = true,
	underline = false,
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
