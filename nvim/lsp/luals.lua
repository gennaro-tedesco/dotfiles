return {
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
	},
	settings = {
		Lua = {
			format = { enable = false },
			hint = { enable = true },
			runtime = { version = "LuaJIT" },
			diagnostics = {
				globals = { "describe", "it", "setup", "teardown" },
				disable = { "missing-fields" },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
					vim.api.nvim_get_runtime_file("", true),
				},
				checkThirdParty = false,
			},
			telemetry = { enable = false },
			codeLens = { enable = true },
		},
	},
}
