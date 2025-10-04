local sidekick_ok, sidekick = pcall(require, "sidekick")
if not sidekick_ok then
	return
end

local M = {}

---@class sidekick.Config
M.opts = {
	cli = {
		win = { split = { width = 0.5 } },
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
			require("sidekick.cli").toggle({ filter = { installed = true } })
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
		mode = { "x" },
	},
	{
		"<leader>cp",
		function()
			require("sidekick.cli").prompt()
		end,
		desc = "Sidekick AI prompt",
		mode = { "n", "x" },
	},
}

return M
