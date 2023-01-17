vim.filetype.add({
	filename = {
		[".env"] = "config",
		[".todo"] = "txt",
	},
	pattern = {
		["req.*.txt"] = "config",
		["gitconf.*"] = "gitconfig",
	},
})
