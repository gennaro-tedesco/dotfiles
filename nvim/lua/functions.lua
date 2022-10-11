local notify = require("notify")

local M = {}

M.count_matches = function()
	local cur_word = vim.fn.expandcmd("<cword>")
	local count = vim.api.nvim_exec("%s/" .. cur_word .. "//ng", true)
	notify(" " .. count, "info", { title = "search: " .. cur_word, render = "simple" })
end

M.replace_grep = function()
	local cur_word = vim.fn.expand("<cword>")
	if cur_word ~= "" then
		local replace_word = vim.fn.input("Enter replace word: ")
		vim.cmd("Rg " .. cur_word)
		if replace_word ~= "" then
			vim.cmd("cdo s/" .. cur_word .. "/" .. replace_word)
			vim.cmd("cclose")
			notify(" replace: " .. cur_word .. " --> " .. replace_word)
		end
	end
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
	vim.api.nvim_exec(string.format("keepjumps keeppatterns silent! %s", pattern), false)
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

P = function(v)
	print(vim.inspect(v))
	return v
end

RELOAD = function(...)
	return require("plenary.reload").reload_module(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end

return M
