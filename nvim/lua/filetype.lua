vim.filetype.add({
	filename = {
		[".env"] = "config",
		[".todo"] = "txt",
	},
	pattern = {
		[".*%.cheat"] = "sh",
		["%.?env.*"] = "config",
		["%.?config*"] = "config",
		["gitconf.*"] = "gitconfig",
		[".*/%.dockerignore"] = "gitignore",
		[".*vifm.*"] = "vim",
		["%.?visidata.*"] = "python",
	},
})
