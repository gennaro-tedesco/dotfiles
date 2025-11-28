return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json" },
	init_options = {
		provideFormatter = false,
	},
	settings = {},
}
