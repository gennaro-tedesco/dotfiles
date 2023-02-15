vim.filetype.add({
	filename = {
		[".env"] = "config",
		[".todo"] = "txt",
		[".dockerignore"] = "gitignore",
	},
	pattern = {
		["req.*.txt"] = "config",
		["env.*"] = "config",
		["gitconf.*"] = "gitconfig",
	},
})
