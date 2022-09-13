local notify = require("notify")

local function count_matches()
   local cur_word = vim.fn.expandcmd('<cword>')
   local count = vim.api.nvim_exec('%s/'..cur_word..'//ng', true)
   notify(' '..count, "info")
end

local function copy_error()
   local error_message = vim.fn.trim(vim.fn.execute('1messages'))
   if error_message ~= "" then
	  notify(error_message, "error", {title = "copied message", render = "default"})
	  vim.cmd("let @*='"..error_message.."'")
   else
	  notify(' No new messages', "info")
   end
end

return {count_matches = count_matches, copy_error = copy_error}
