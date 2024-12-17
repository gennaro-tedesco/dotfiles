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
		toml = { "taplo" },
		yaml = { "prettier" },
	},
	format_on_save = function()
		local next = next
		--- check if we have to skip formatting due to lsp errors
		if next(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })) ~= nil and not override_lsp() then
			local clients = require("utils").clients_lsp()
			local icons = require("utils").icons
			---@module 'snacks'
			Snacks.notifier.notify(
				"LSP errors, cannot format: "
					.. #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					.. icons.statusline.Error
					.. " "
					.. #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					.. icons.statusline.Warn,
				"warn",
				{ title = clients, style = "compact", ft = "txt", id = "lsp_error" }
			)
			return
		end
		return { timeout_ms = 5000, lsp_fallback = true }
	end,
})
