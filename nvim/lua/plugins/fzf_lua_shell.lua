local cli_profile = require("fzf-lua.profiles.cli")
require("fzf-lua").setup({
	{ "cli" },
	fzf_opts = {
		["--border"] = "--no-border",
		["--info"] = "hidden",
		["--no-header"] = "",
		["--no-scrollbar"] = "",
		["--border-label-pos"] = "4:top",
	},
	previewers = { bat = { args = "--color=always --style=numbers" } },
	grep = {
		actions = {
			["enter"] = cli_profile.actions.files["ctrl-q"],
		},
		prompt = false,
		fzf_opts = {
			["--ghost"] = "search pattern",
		},
		keymap = {
			fzf = {
				["ctrl-a"] = "select-all",
			},
		},
	},
})
