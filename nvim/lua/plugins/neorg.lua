local M = {}

M.opts = {
	load = {
		["core.defaults"] = {},
		["core.syntax"] = {},
		["core.dirman"] = {
			config = {
				workspaces = {
					notes = "~/notes",
				},
				default_workspace = "notes",
			},
		},
		["core.highlights"] = {
			config = {
				highlights = {
					headings = {
						["1"] = {
							title = "+@comment.todo",
							prefix = "+@comment.todo",
						},
						["2"] = {
							title = "+@type",
							prefix = "+@type",
						},
						["3"] = {
							title = "+@number",
							prefix = "+@number",
						},
						["4"] = {
							title = "+@constructor",
							prefix = "+@constructor",
						},
					},
				},
			},
		},
		["core.keybinds"] = {
			config = {
				default_keybinds = false,
			},
		},
		["core.todo-introspector"] = {
			config = {
				highlight_group = "@comment",
			},
		},
		["core.concealer"] = {
			config = {
				folds = false,
				icons = { todo = { pending = { icon = "✘" } } },
			},
		},
	},
}

return M
