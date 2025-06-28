return {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "terraform-vars" },
	root_markers = { ".terraform" },
	init_options = {
		ignoreSingleFileWarning = true,
	},
}
