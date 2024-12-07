local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
	return
end

------------------------
--- global functions ---
------------------------
_G.P = function(...)
	snacks.notify.info(vim.inspect(...), { ft = "lua" })
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
		Boolean = "◩",
		Copilot = "",
		Class = "󰠱",
		Color = "󰏘",
		Constant = "󰏿",
		Constructor = "",
		Enum = "",
		EnumMember = "",
		Event = "",
		Field = "󰆨",
		File = "󰈙",
		Folder = "󰉋",
		Function = "ƒ",
		Interface = "",
		Key = "",
		Keyword = "󰌋",
		Method = "󰆧",
		Module = "󰏗 ",
		Namespace = "󰅩",
		Number = "󰎠",
		Null = "󰟢",
		Object = "⦿",
		Operator = "+",
		Package = "󰏗",
		Property = "󰜢",
		Reference = "",
		Snippet = "",
		String = "𝓐",
		Struct = "󰙅",
		Text = "",
		TypeParameter = "󰆩",
		Unit = "",
		Value = "󰎠",
		Variable = "󰀫",
	},
	cmp_sources = {
		copilot = "🤖",
		nvim_lsp = "✨",
		luasnip = "🚀",
		buffer = "📝",
		path = "📁",
		cmdline = "💻",
	},
	statusline = {
		Error = "❗",
		Warn = "⚠️ ",
		Hint = "i",
		Info = "💡",
	},
}

M.is_in_list = function(value, list)
	for _, v in pairs(list) do
		if v == value then
			return true
		end
	end
	return false
end

M.count_matches = function()
	local cur_word = vim.fn.expandcmd("<cword>")
	local count = vim.api.nvim_exec2("%s/" .. cur_word .. "//ng", { output = true }).output
	snacks.notifier.notify(" " .. count, "info", { title = "search: " .. cur_word, style = "compact" })
end

M.hl_search = function(blinktime)
	local ns = vim.api.nvim_create_namespace("search")
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

	local search_pat = "\\c\\%#" .. vim.fn.getreg("/")
	local ring = vim.fn.matchadd("IncSearch", search_pat)
	vim.cmd("redraw")
	vim.cmd("sleep " .. blinktime * 1000 .. "m")

	local sc = vim.fn.searchcount()
	vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
		virt_text = { { "[" .. sc.current .. "/" .. sc.total .. "]", "Comment" } },
		virt_text_pos = "eol",
	})

	vim.fn.matchdelete(ring)
	vim.cmd("redraw")
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
		print("qf list empty")
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
		print("loc list empty")
		return
	end
	vim.cmd("lopen")
end

M.t2s = function()
	vim.o.expandtab = true
	vim.cmd("%retab!")
	vim.cmd("write")
end

M.s2t = function()
	vim.o.expandtab = false
	vim.cmd("%retab!")
	vim.cmd("write")
end

M.replace_file = function()
	vim.cmd("silent execute 'norm gg" .. '"' .. "_dGP'")
end

M.git_root = function()
	local git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(git_path, ":h")
end

M.jumps_to_qf = function()
	local jumplist, _ = unpack(vim.fn.getjumplist())
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
	local bufnr = vim.api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if next(clients) == nil then
		return ""
	end

	local c = {}
	for _, client in pairs(clients) do
		table.insert(c, client.name)
	end
	return table.concat(c, "|")
end

return M
