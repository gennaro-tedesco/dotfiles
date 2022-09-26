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
		vim.cmd("cdo s/" .. cur_word .. "/" .. replace_word .. "/g")
		vim.cmd("cclose")
		notify(" replace: " .. cur_word .. " --> " .. replace_word)
	end
end

return { count_matches = count_matches, copy_error = copy_error, replace_grep = replace_grep }
