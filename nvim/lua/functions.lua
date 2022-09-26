local notify = require("notify")

local function count_matches()
	local cur_word = vim.fn.expandcmd("<cword>")
	local count = vim.api.nvim_exec("%s/" .. cur_word .. "//ng", true)
	notify(" " .. count, "info", { title = "search: " .. cur_word, render = "simple" })
end

local function copy_error()
	local error_message = vim.fn.trim(vim.fn.execute("1messages"))
	if error_message ~= "" then
		notify(error_message, "error", { title = "message copied!", render = "simple" })
		vim.cmd("let @*='" .. error_message .. "'")
	else
		notify(" No new messages", "info")
	end
end

local function replace_grep()
	local cur_word = vim.fn.expandcmd("<cword>")
	local replace_word = vim.fn.input("Enter replace word: ")
	vim.cmd("Rg " .. cur_word)
	if replace_word ~= "" then
		vim.cmd("cdo s/" .. cur_word .. "/" .. replace_word)
		vim.cmd("cclose")
		notify(" replace: " .. cur_word .. " --> " .. replace_word)
	end
end

local function hl_search(blinktime)
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

return { count_matches = count_matches, copy_error = copy_error, replace_grep = replace_grep, hl_search = hl_search }
