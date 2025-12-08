---@diagnostic disable: inject-field
require("fzf-lua").setup({
	{ "cli" },
	---@diagnostic disable-next-line: missing-fields
	fzf_opts = {
		["--border"] = "--no-border",
		["--info"] = "hidden",
		["--no-header"] = "",
		["--no-scrollbar"] = "",
		["--border-label-pos"] = "4:top",
	},
	---@diagnostic disable-next-line: missing-fields
	previewers = { bat = { args = "--color=always --style=numbers" } },
	grep = {
		prompt = false,
		---@diagnostic disable-next-line: param-type-mismatch
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
