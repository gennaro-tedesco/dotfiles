return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json" },
	settings = {
		html = {
			format = {
				templating = true,
				wrapLineLength = 100,
			},
		},
	},
}
