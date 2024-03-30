local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
	return
end

local function override_lsp()
	local lsp_error_override = { "yamlls" }
	local active_lsp = require("utils").clients_lsp()
	for _, client in ipairs(lsp_error_override) do
		if string.match(client, active_lsp) then
			return true
		end
	end
end

conform.setup({
	formatters_by_ft = {
		json = { "jq" },
		go = { "gofmt", "goimports" },
		latex = { "latexindent" },
		lua = { "stylua" },
		markdown = { "prettier" },
		python = { "isort", "black" },
		rust = { "rustfmt" },
		sh = { "shfmt" },
		sql = { "sqlfluff" },
		toml = { "taplo" },
		yaml = { "prettier" },
	},
	format_on_save = function()
		local next = next
		--- check if we have to skip formatting due to lsp errors
		if next(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })) ~= nil and not override_lsp() then
			local notify_ok, notify = pcall(require, "notify")
			if not notify_ok then
				return
			end
			notify("LSP errors, cannot format")
			return
		end
		return { timeout_ms = 5000, lsp_fallback = true }
	end,
})
