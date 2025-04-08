---------------------------------
--- general lsp configuration ---
---------------------------------
vim.lsp.config("*", {
	root_markers = { ".git" },
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
})

local configs = {}

for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
	local name = vim.fn.fnamemodify(v, ":t:r")
	configs[name] = true
end

vim.lsp.enable(vim.tbl_keys(configs))

-------------------------------------------
--- diagnostics: linting and formatting ---
-------------------------------------------
local icons = require("utils").icons
local diagnostic_signs = {
	[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
	[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
	[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
	[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
}

local function diagnostic_format(diagnostic)
	return string.format(
		"%s %s [%s]",
		diagnostic_signs[diagnostic.severity],
		diagnostic.message:gsub("%.$", ""),
		diagnostic.source:gsub("%.$", "")
	)
end

---@type vim.diagnostic.Opts
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { current_line = true, format = diagnostic_format },
	underline = true,
	signs = { text = diagnostic_signs },
	severity_sort = true,
	---@type vim.diagnostic.Opts.Float
	float = {
		border = "rounded",
		source = false,
		header = "",
		prefix = "",
		focusable = false,
		format = diagnostic_format,
	},
})

---------------
--- keymaps ---
---------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		local opts = { noremap = true, silent = true }
		local bufopts = { noremap = true, silent = true, buffer = bufnr }

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

		--- toggle virtual lines
		local function toggle_lines()
			local tl = vim.api.nvim_create_augroup("ToggleLines", {})
			if vim.diagnostic.config().virtual_lines == false then
				vim.diagnostic.config({ virtual_lines = { current_line = true, format = diagnostic_format } })
				vim.api.nvim_clear_autocmds({ group = tl })
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_config(win).relative ~= "" then
						vim.api.nvim_win_close(win, true)
					end
				end
			else
				vim.diagnostic.config({ virtual_lines = false })
				vim.diagnostic.open_float()
				vim.api.nvim_clear_autocmds({ group = tl })
				vim.api.nvim_create_autocmd("CursorMoved", {
					group = tl,
					desc = "toggle virtual lines vs diagnostic float",
					callback = function()
						vim.diagnostic.open_float()
					end,
				})
			end
		end

		vim.keymap.set(
			"n",
			"d/",
			vim.diagnostic.setloclist,
			vim.tbl_extend("force", opts, { desc = "✨lsp send diagnostics to loc list" })
		)
		vim.keymap.set(
			"n",
			"de",
			-- vim.diagnostic.open_float,
			toggle_lines,
			vim.tbl_extend("force", opts, { desc = "✨lsp show diagnostic in floating window" })
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

-------------------
--- lsp logging ---
-------------------
vim.lsp.set_log_level("off")
