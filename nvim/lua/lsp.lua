--------------------------------------------------------
--- configuration of the individual language servers ---
--------------------------------------------------------

--- bashls
vim.lsp.config["bashls"] = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh" },
	root_markers = { ".git" },
}
vim.lsp.enable("bashls")

--- basedpyright
vim.lsp.config["basedpyright"] = {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				autoImportCompletions = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
}
vim.lsp.enable("basedpyright")

--- cssls
vim.lsp.config["cssls"] = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { "package.json", ".git" },
}
vim.lsp.enable("cssls")

--- dockerls
vim.lsp.config["dockerls"] = {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile" },
}
vim.lsp.enable("dockerls")

--- html
vim.lsp.config["html"] = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },
	settings = {
		html = {
			format = {
				templating = true,
				wrapLineLength = 100,
			},
		},
	},
}
vim.lsp.enable("html")

--- gopls
vim.lsp.config["gopls"] = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "main.go", ".git" },
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
}
vim.lsp.enable("gopls")

--- jsonls
vim.lsp.config["jsonls"] = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json" },
	root_markers = { ".git" },
}
vim.lsp.enable("jsonls")

--- luals
vim.lsp.config["luals"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
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
}
vim.lsp.enable("luals")

--- marksman
vim.lsp.config["marksman"] = {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".marksman.toml" },
}
vim.lsp.enable("marksman")

--- rust-analyzer
vim.lsp.config["rust-analyzer"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "Cargo.lock" },
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
		},
	},
}
vim.lsp.enable("rust-analyzer")

--- taplo
vim.lsp.config["taplo"] = {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_markers = { ".git" },
}
vim.lsp.enable("taplo")

--- terraformls
vim.lsp.config["terraformls"] = {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "terraform-vars" },
	root_markers = { ".terraform", ".git" },
}
vim.lsp.enable("terraformls")

--- texlab
vim.lsp.config["texlab"] = {
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	root_markers = { ".git", ".latexmkrc", ".texlabroot", "texlabroot", "Tectonic.toml" },
}
vim.lsp.enable("texlab")

--- ts_ls
vim.lsp.config["ts_ls"] = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}
vim.lsp.enable("ts_ls")

--- vimls
vim.lsp.config["vimls"] = {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	root_markers = { ".git" },
}
vim.lsp.enable("vimls")

--- yamlls
vim.lsp.config["yamlls"] = {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose" },
	root_markers = { ".git" },
}
vim.lsp.enable("yamlls")

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
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
			vim.keymap.set("n", "<leader>a", function()
				require("fzf-lua").lsp_code_actions()
			end, { desc = "✨lsp code actions" })
		end
	end,
})

-------------------------------------------
--- diagnostics: linting and formatting ---
-------------------------------------------
local icons = require("utils").icons

---@type vim.diagnostic.Opts
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { current_line = true },
	underline = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
		},
	},
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

-------------------
--- lsp logging ---
-------------------
vim.lsp.set_log_level("off")
