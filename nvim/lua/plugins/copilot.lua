local ok, chat = pcall(require, "CopilotChat")
if not ok then
	return
end

local icons = require("utils").icons
local copilot_utils = require("CopilotChat.utils")

local function get_diagnostics()
	local diagnostics = vim.diagnostic.get(nil)
	local lines = {}
	local severity_labels = {
		[vim.diagnostic.severity.ERROR] = "ERROR",
		[vim.diagnostic.severity.WARN] = "WARN",
		[vim.diagnostic.severity.INFO] = "INFO",
		[vim.diagnostic.severity.HINT] = "HINT",
	}

	copilot_utils.schedule_main()
	for _, d in ipairs(diagnostics) do
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(d.bufnr), ":.")
		table.insert(
			lines,
			string.format(
				"%s:%d - %s - %s",
				filename,
				(d.lnum or 0) + 1,
				severity_labels[d.severity] or "",
				d.message or ""
			)
		)
	end
	return {
		{
			content = table.concat(lines, "\n"),
			filename = "workspace_diagnostics",
			filetype = "text",
		},
	}
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
	contexts = {
		diagnostics = {
			description = "workspace diagnostics as context",
			resolve = get_diagnostics,
		},
	},
	context = { "buffers", "diagnostics" },
	system_prompt = concise_prompt,
	question_header = "# ",
	answer_header = "# 🤖 🤖",
	auto_follow_cursor = false,
	error_header = "### " .. icons.statusline.Error,
	highlight_headers = false,
	separator = "",
	prompts = {
		Diagnostic = {
			prompt = diagnostics_prompt,
			context = { "buffers", "diagnostics" },
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
