return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh" },
	cmd_env = {
		GLOB_PATTERN = "*@(.sh|.bash)",
	},
}
