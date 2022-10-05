vim.filetype.add({
	filename = {
		[".env"] = "config",
	},
	pattern = {
		["req.*.txt"] = "config",
		["gitconf.*"] = "gitconfig",
	},
})
