local ok, chat = pcall(require, "CopilotChat")
if not ok then
	return
end

local icons = require("utils").icons

local concise_prompt = [[
	1. be concise and to the point
	2. only answer the question asked
	3. when possible, provide references to documentation
	4. only give links if they exist and are not 404
	5. if you spot a mistake in your reasoning, please auto-correct the answer automatically
	6. when providing code, do so without code comments
	]]

chat.setup({
	model = "claude-sonnet-4",
	context = { "buffers" },
	system_prompt = concise_prompt,
	question_header = "# ",
	answer_header = "# 🤖 🤖",
	auto_follow_cursor = false,
	error_header = "### " .. icons.statusline.Error,
	highlight_headers = false,
	separator = "",
	mappings = {
		accept_diff = {
			normal = "gp",
			insert = "gp",
		},
		show_diff = {
			full_diff = true,
		},
		show_help = { normal = "g?" },
		stop = {
			normal = "<C-c>",
			callback = function()
				require("CopilotChat").stop()
			end,
		},
	},
	providers = {
		github_models = {
			disabled = true,
		},
	},
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		vim.opt_local.conceallevel = 0
	end,
})
