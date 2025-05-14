vim.filetype.add({
	extension = {
		cheat = "cheat",
		pgn = "pgn",
	},
	filename = {
		[".env"] = "config",
		[".todo"] = "markdown",
		["Brewfile"] = "bash",
	},
	pattern = {
		["requirements.*"] = "requirements",
		["%.?env.*"] = "config",
		["%.?config*"] = "config",
		["gitconf.*"] = "gitconfig",
		[".*/%.dockerignore"] = "gitignore",
		[".*vifm.*"] = "vim",
		["%.?visidata.*"] = "python",
	},
})
