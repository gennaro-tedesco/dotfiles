vim.filetype.add({
	extension = {
		cheat = "cheat",
		pgn = "pgn",
		stardict = "stardict",
		log = "log",
	},
	filename = {
		[".env"] = "config",
		[".todo"] = "norg",
		["Brewfile"] = "bash",
	},
	pattern = {
		["requirements.*"] = "requirements",
		[".*%.env"] = "config",
		["%.?config*"] = "config",
		["gitconf.*"] = "gitconfig",
		[".*/%.dockerignore"] = "gitignore",
		[".*vifm.*"] = "vim",
		["%.?visidata.*"] = "python",
	},
})
