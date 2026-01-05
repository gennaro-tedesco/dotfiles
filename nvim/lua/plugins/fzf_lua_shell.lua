local cli_profile = require("fzf-lua.profiles.cli")
local path = require("fzf-lua.path")

local function view(filepath)
	local ext = vim.fn.fnamemodify(filepath, ":e"):lower()
	if filepath == "-E" then
		os.execute("bat --style='header,grid' .env 2>/dev/null")
	elseif ext == "md" then
		os.execute(string.format("glow -p %q", filepath))
	elseif ext == "json" then
		os.execute(string.format("jq '.' -C %q | less -R", filepath))
	elseif ext == "csv" then
		os.execute(string.format("xan view %q", filepath))
	elseif ext == "pdf" then
		vim.fn.jobstart(string.format("zathura %q", filepath), { detach = true })
	elseif ext == "jpg" or ext == "jpeg" or ext == "png" then
		os.execute(string.format("wezterm imgcat %q", filepath))
	else
		os.execute(string.format("bat --style='header,grid' %q", filepath))
	end
end

require("fzf-lua").setup({
	{ "cli" },
	fzf_opts = {
		["--border"] = "--no-border",
		["--info"] = "hidden",
		["--no-header"] = "",
		["--no-scrollbar"] = "",
	},
	previewers = { bat = { args = "--color=always --style=numbers" } },
	files = {
		no_header = true,
		cwd_header = false,
		cwd_prompt = false,
		winopts = {
			preview = { hidden = "hidden" },
		},
		fzf_opts = {
			["--ghost"] = "search files",
		},
		actions = {
			["enter"] = cli_profile.actions.files["ctrl-q"],
			["ctrl-v"] = function(selected)
				for _, file in ipairs(selected) do
					local entry = path.entry_to_file(file)
					if entry and entry.path then
						view(entry.path)
					end
				end
			end,
		},
		keymap = {
			fzf = {
				["ctrl-a"] = "select-all",
			},
		},
	},
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
	git = {
		status = {
			cwd_header = false,
			cwd_prompt = false,
			winopts = {
				preview = { hidden = "hidden" },
			},
			fzf_opts = {
				["--ghost"] = "search modified files",
			},
			actions = {
				["enter"] = cli_profile.actions.files["ctrl-q"],
			},
			keymap = {
				fzf = {
					["ctrl-a"] = "select-all",
				},
			},
		},
	},
})
