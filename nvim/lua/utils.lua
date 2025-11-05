local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
	vim.notify("snacks not installed, notifications not available", vim.log.levels.WARN)
end

------------------------
--- global functions ---
------------------------
_G.P = function(...)
	snacks.notify.info(vim.inspect(...), { ft = "lua" })
end
_G.bt = function()
	snacks.debug.backtrace()
end

vim.print = _G.P

local M = {}

M.icons = {
	diagnostics = { Error = "✘", Warn = "", Hint = "i", Info = "i" },
	git = {
		Add = "+",
		Change = "~",
		Delete = "-",
	},
	kinds = {
		Array = "󰅪",
		Branch = "",
		Boolean = "󰨙",
		Class = "󰠱",
		Color = "󰏘",
		Constant = "λ",
		Constructor = "",
		Enum = "",
		EnumMember = "",
		Event = "",
		Field = "",
		File = "",
		Folder = "󰉋",
		Function = "𝒇",
		Interface = "",
		Key = "",
		Keyword = "",
		Method = "󰆧",
		Module = "󰏗 ",
		Namespace = "󰅩",
		Number = "󰎠",
		Null = "",
		Object = "",
		Operator = "+",
		Package = "",
		Property = "󰜢",
		Reference = "",
		Snippet = "",
		String = "𝓐",
		Struct = "󰙅",
		Text = "",
		TypeParameter = "󰆩",
		Unit = "",
		Value = "󰎠",
		Variable = "󰫧",
	},
	cmp_sources = {
		LSP = "✨",
		Luasnip = "🚀",
		Snippets = "🚀",
		Buffer = "📝",
		Path = "📁",
		Cmdline = "💻",
		copilot = "🤖",
	},
	statusline = {
		Error = "❌",
		Warn = "⚠️",
		Hint = "i",
		Info = "💡",
	},
}

M.count_matches = function()
	local cur_word = vim.fn.expandcmd("<cword>")
	local count = vim.api.nvim_exec2("%s/" .. cur_word .. "//ng", { output = true }).output
	snacks.notifier.notify(" " .. count, "info", { title = "🔎 " .. cur_word, style = "compact", id = "search" })
end

M.hl_search = function(blinktime)
	local search_reg = vim.fn.getreg("/")
	local ring = vim.fn.matchadd("IncSearch", search_reg)

	vim.defer_fn(function()
		vim.fn.matchdelete(ring)
	end, blinktime * 1000)
end

M.project_search = function()
	vim.ui.input({ prompt = "regex: " }, function(input)
		if input == "" or input == nil then
			return
		else
			vim.cmd.grep({ mods = { silent = true }, bang = true, '"' .. input .. '"' })
			vim.schedule(function()
				local qf_list = vim.fn.getqflist()
				if #qf_list == 0 then
					vim.notify(
						"no matches found for: " .. input,
						vim.log.levels.WARN,
						{ style = "compact", title = "grep", id = "grep" }
					)
				end
			end)
		end
	end)
end

M.buffers_search = function()
	vim.fn.setqflist({}, " ")
	vim.ui.input({ prompt = "regex in open buffers: " }, function(input)
		if input == "" or input == nil then
			return
		else
			vim.cmd({ cmd = "bufdo", args = { "vimgrepadd " .. input .. " % " }, bang = true, mods = { silent = true } })
		end
	end)
end

M.trim_whitespace = function()
	local pattern = [[%s/\s\+$//e]]
	local cur_view = vim.fn.winsaveview()
	vim.api.nvim_exec2(string.format("keepjumps keeppatterns silent! %s", pattern), { output = false })
	vim.fn.winrestview(cur_view)
end

M.toggle_qf = function()
	for _, info in ipairs(vim.fn.getwininfo()) do
		if info.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end

	if next(vim.fn.getqflist()) == nil then
		vim.print("qf list empty")
		return
	end
	vim.cmd("copen")
end

M.toggle_ll = function()
	for _, info in ipairs(vim.fn.getwininfo()) do
		if info.loclist == 1 then
			vim.cmd("lclose")
			return
		end
	end

	if next(vim.fn.getloclist(0)) == nil then
		vim.print("loc list empty")
		return
	end
	vim.cmd("lopen")
end

M.replace_file = function()
	vim.cmd("silent execute 'norm gg" .. '"' .. "_dGP'")
end

M.git_root = function()
	return vim.fs.root(0, { ".git" })
end

M.jumps_to_qf = function()
	local jumplist = vim.fn.getjumplist()[1]
	local qf_list = {}
	for _, v in pairs(jumplist) do
		if vim.fn.bufloaded(v.bufnr) == 1 then
			table.insert(qf_list, {
				bufnr = v.bufnr,
				lnum = v.lnum,
				col = v.col,
				text = vim.api.nvim_buf_get_lines(v.bufnr, v.lnum - 1, v.lnum, false)[1],
			})
		end
	end
	vim.fn.setqflist(qf_list, " ")
	vim.cmd("copen")
end

M.clients_lsp = function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return ""
	end
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return table.concat(names, "|")
end

M.gbrowse = function()
	local root = vim.system({ "git", "root" }, { text = true }):wait()
	if root.code ~= 0 then
		vim.notify(
			"not a git repository",
			vim.log.levels.WARN,
			{ style = "compact", title = " gh browse", id = "Gbrowse" }
		)
		return
	end

	local filename = vim.fn.expand("%:p:~:.")
	if filename == "" then
		vim.notify("no filename", vim.log.levels.ERROR, { style = "compact", title = " gh browse", id = "Gbrowse" })
		return
	end

	local lnum = vim.api.nvim_win_get_cursor(0)[1]

	vim.system({ "git", "branch", "--show-current" }, { text = true }, function(branch_result)
		if branch_result.code ~= 0 then
			vim.notify(
				"failed to get current branch",
				vim.log.levels.ERROR,
				{ style = "compact", title = " gh browse", id = "Gbrowse" }
			)
			return
		end

		local branch = vim.trim(branch_result.stdout)

		vim.system({ "gh", "browse", "-b", branch, filename .. ":" .. lnum }, { text = true }, function(result)
			if result.code ~= 0 then
				local error_msg = result.stderr and vim.trim(result.stderr) or "unknown error"
				vim.notify(
					"gh browse failed: " .. error_msg,
					vim.log.levels.ERROR,
					{ style = "compact", title = " gh browse", id = "Gbrowse" }
				)
			end
		end)
	end)
end
return M
