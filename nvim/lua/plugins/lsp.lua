local lsp_ok, lsp = pcall(require, "lspconfig")
if not lsp_ok then
	return
end

local icons = require("utils").icons

-- local capabilities = require("blink.cmp").get_lsp_capabilities()

---------------
--- keymaps ---
---------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		local opts = { noremap = true, silent = true }

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
		vim.keymap.set(
			"n",
			"K",
			vim.lsp.buf.hover,
			vim.tbl_extend("force", bufopts, { desc = "✨lsp hover for docs" })
		)
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
			vim.ui.input({ prompt = "rename: ", default = vim.fn.expand("<cword>") }, function(input)
				if input == "" or input == nil then
					return
				else
					vim.lsp.buf.rename(input)
				end
			end)
		end, { desc = "✨lsp rename symbol" })
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
	end,
})

local lsp_flags = { debounce_text_changes = 150 }
vim.lsp.set_log_level("debug")
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
--------------------------------------------------------
--- configuration of the individual language servers ---
--------------------------------------------------------

---bashls
lsp.bashls.setup({ filetypes = { "sh" } })

--- dockerfile ls
lsp.dockerls.setup({})

---gopls
lsp.gopls.setup({
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

lsp.marksman.setup({ lsp_flags = lsp_flags })

---sumneko_lua
lsp.lua_ls.setup({
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
	settings = {
		html = {
			format = {
				templating = true,
				wrapLineLength = 100,
			},
		},
	},
})

---basedpyright language server
lsp.basedpyright.setup({
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				autoImportCompletions = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
	lsp_flags = lsp_flags,
})

---jsonls
lsp.jsonls.setup({})

---rust_analyzer
lsp.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
		},
	},
	lsp_flags = lsp_flags,
})

---texlab
lsp.texlab.setup({})

---taplo toml
lsp.taplo.setup({})

---terraform
lsp.terraformls.setup({})

---typescript
lsp.ts_ls.setup({})

---vimls
lsp.vimls.setup({})

---yamlls
lsp.yamlls.setup({})

-------------------------------------------
--- diagnostics: linting and formatting ---
-------------------------------------------
---@type vim.diagnostic.Opts
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	signs = true,
	severity_sort = true,
	---@type vim.diagnostic.Opts.Float
	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = function(d)
			local d_icon = {
				[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
				[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
				[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
				[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			}
			local d_hl = {
				[vim.diagnostic.severity.HINT] = "DiagnosticHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
				[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
				[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			}
			return d_icon[d.severity] .. " ", d_hl[d.severity]
		end,
		focusable = false,
	},
})

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
