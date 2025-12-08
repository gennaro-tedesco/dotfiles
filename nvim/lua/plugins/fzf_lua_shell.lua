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
		actions = {
			["enter"] = function(s)
				for _, entry in ipairs(s) do
					local path, lnum, text = entry:match("^(.-):(%d+):(.*)$")
					if path and lnum then
						io.stdout:write(string.format("%s:%d:%d:%s\n", path, tonumber(lnum), 1, vim.trim(text)))
					end
				end

				vim.cmd.quit()
			end,
		},

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
