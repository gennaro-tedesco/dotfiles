local sidekick_ok, sidekick = pcall(require, "sidekick")
if not sidekick_ok then
	return
end

local M = {}

---@class sidekick.Config
M.opts = {
	cli = {
		win = { split = { width = 0.5 } },
		prompts = {
			fix_diagnostics = [[
			1. Fix all {diagnostics} warnings and errors in {file}
			2. Show different code patches for each diagnostic.
			3. Start from current open buffer first.
			4. Display results with following markdown:
				> `<filename>`: <start line>-<end line> <diagnostic type> - <diagnostic message>\n
			5. Show each diagnostic as code diff in format git diff -U0; remove file names and line numbers
			6. Separate each patch with a horizontal markdown line
			]],
		},
	},
}

M.keys = {
	{
		"<tab>",
		function()
			if not require("sidekick.nes").apply() then
				return "<Tab>"
			end
		end,
		expr = true,
		desc = "Sidekick NES",
	},
	{
		"<c-.>",
		function()
			require("sidekick.cli").focus()
		end,
		mode = { "n", "x", "i", "t" },
		desc = "Sidekick Switch Focus",
	},
	{
		"<leader>ct",
		function()
			require("sidekick.cli").toggle()
		end,
		desc = "Sidekick AI toggle",
		mode = { "n", "t" },
	},
	{
		"<leader>ct",
		function()
			require("sidekick.cli").send({ msg = "{selection}" })
		end,
		desc = "Sidekick AI send visual selection",
		mode = { "v" },
	},
	{
		"<leader>cp",
		function()
			require("sidekick.cli").prompt()
		end,
		desc = "Sidekick AI prompt",
		mode = { "n", "v" },
	},
}

return M
