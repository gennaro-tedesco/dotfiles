local ok, chat = pcall(require, "CopilotChat")
if not ok then
	return
end

local concise_prompt = [[
	1. be concise and to the point
	2. only answer the question asked
	3. when possible, provide references to documentation
	4. only give links if they exist and are not 404
	5. if you spot a mistake in your reasoning, please auto-correct the answer automatically
	6. when providing code, do so without code comments
	]]

local diagnostics_prompt = [[
	1. Fix all LSP warnings and errors.
	2. Show different code patches for each diagnostic.
	3. Start from current open buffer first.
	4. Display results with following markdown:
		> `<filename>`: <start line>-<end line> <diagnostic type> - <diagnostic message>\n
	5. Show each diagnostic as code diff in format git diff -U0; remove file names and line numbers
	6. Separate each patch with a horizontal markdown line
	]]

chat.setup({
	model = "claude-sonnet-4",
	sticky = { "#buffers", "#diagnostics" },
	system_prompt = concise_prompt,
	headers = {
		user = "#   ",
		assistant = "# 🤖 🤖 ",
	},
	auto_follow_cursor = false,
	highlight_headers = true,
	separator = " ",
	prompts = {
		Diagnostic = {
			description = "Fix LSP buffer diagnostics",
			prompt = diagnostics_prompt,
		},
	},
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
