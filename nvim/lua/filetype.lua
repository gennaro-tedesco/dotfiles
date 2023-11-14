vim.filetype.add({
	filename = {
		[".env"] = "config",
		[".todo"] = "txt",
	},
	pattern = {
		["req.*.txt"] = "config",
		["%.?env.*"] = "config",
		["%.?config*"] = "config",
		["gitconf.*"] = "gitconfig",
		[".*/%.dockerignore"] = "gitignore",
		[".*vifm.*"] = "vim",
	},
})
