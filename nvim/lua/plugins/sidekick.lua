local sidekick_ok, _ = pcall(require, "sidekick")
if not sidekick_ok then
	return
end

local M = {}

---@class sidekick.Config
M.opts = {
	nes = { enabled = false },
	cli = {
		win = { split = { width = 0.5 } },
		picker = "fzf-lua",
	},
}

M.keys = {
	{
		"<c-.>",
		function()
			require("sidekick.cli").toggle({ filter = { installed = true } })
		end,
		mode = { "n", "x", "i", "t" },
		desc = "Sidekick Switch Focus",
	},
	{
		"<leader>cv",
		function()
			require("sidekick.cli").send({ msg = "{this}", filter = { installed = true } })
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
