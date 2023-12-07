local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
	return
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
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 500,
	},
})
