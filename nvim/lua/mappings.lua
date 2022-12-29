_G.nnoremap = function(lhs, rhs, opt)
	vim.keymap.set("n", lhs, rhs, opt)
end

_G.inoremap = function(lhs, rhs, opt)
	vim.keymap.set("i", lhs, rhs, opt)
end

_G.vnoremap = function(lhs, rhs, opt)
	vim.keymap.set("v", lhs, rhs, opt)
end

_G.tnoremap = function(lhs, rhs, opt)
	vim.keymap.set("t", lhs, rhs, opt)
end

_G.onoremap = function(lhs, rhs, opt)
	vim.keymap.set("o", lhs, rhs, opt)
end

--- prevent record functionality
nnoremap("q", "<nop>")
nnoremap("qq", "q")

--- remove all trailing spaces
nnoremap("<F5>", "<cmd>lua require('functions').trim_whitespace()<CR>")

--- smarter indenting
vnoremap("<", "<gv")
vnoremap(">", ">gv")
nnoremap(">", ">>")
nnoremap("<", "<<")

--- remapping the escape key
inoremap("jj", "<ESC>")
vnoremap("jj", "<ESC>")
inoremap("kk", "<ESC>")
vnoremap("kk", "<ESC>")

--- treat visual lineas as actual lines
vim.keymap.set({ "n", "v", "o" }, "j", "gj")
vim.keymap.set({ "n", "v", "o" }, "k", "gk")
vim.keymap.set({ "n", "v", "o" }, "<Down>", "gj")
vim.keymap.set({ "n", "v", "o" }, "<Up>", "gk")
inoremap("<Down>", "<C-o>gj")
inoremap("<Up>", "<C-o>gk")
nnoremap("vv", "^vg_")

--- easier navigation
nnoremap("E", "5e")
nnoremap("B", "5b")
nnoremap("H", "^")
onoremap("H", "^")
nnoremap("L", "$")
onoremap("L", "$")
nnoremap("<PageUp>", "k{j")
nnoremap("<PageDown>", "j}k")
vnoremap("<PageUp>", "k{j")
vnoremap("<PageDown>", "j}k")
nnoremap("<Tab>", "<C-w>w")
nnoremap("<S-Tab>", "<C-w>W")

--- close all splits/windows except the one in focus
nnoremap("<leader>q", "<C-w>o")

--- avoid x and s to override the clipboard
nnoremap("x", '"_x')
nnoremap("s", '"_s')
nnoremap("X", '"_X')

--- replace a word with yanked text
nnoremap("rw", "viwpyiw", { desc = "replace a word with yanked text" })

--- replace till the end of line with yanked text
nnoremap("rl", 'Pl"_D', { desc = "replace till end of the line" })

--- toggle capitalisation
nnoremap("<leader>w", "g~iw")
vnoremap("<leader>w", "~")

--- copy file name to the clipboard
nnoremap("yf", function()
	local filename = vim.api.nvim_buf_get_name(0)
	vim.fn.setreg("+", filename)
	print("copied " .. filename)
end, { desc = "copy file name to clipboard" })

--- count all occurrences of word under cursor
nnoremap("*", "*<cmd>lua require('functions').count_matches()<CR>", { desc = "count matches for word under cursor" })

--- blink word under cursor in search mode
nnoremap("n", "nzz<cmd>lua require('functions').hl_search(0.3)<CR>", { desc = "go to next search and highlight" })
nnoremap("N", "Nzz<cmd>lua require('functions').hl_search(0.3)<CR>", { desc = "go to prev search and highlight" })

--- quickfix and sessions
nnoremap("<C-q>", "<cmd> lua require('functions').toggle_qf()<CR>", { desc = "toggle quickfix" })
nnoremap("<C-l>", "<cmd> lua require('functions').toggle_ll()<CR>", { desc = "toggle loc list" })
nnoremap("<leader>sn", "<cmd> lua require('plugins.sessions').new()<CR>", { desc = "📌sessions new" })
nnoremap("<leader>su", "<cmd> lua require('plugins.sessions').update()<CR>", { desc = "📌sessions load" })
nnoremap("<leader>sl", "<cmd> lua require('plugins.sessions').list()<CR>", { desc = "📌sessions list" })

--- open todo file in one go
nnoremap("<leader>t", function()
	vim.cmd.edit(vim.fs.normalize("~/.todo"))
end, { desc = "open todo file" })

--- clean up search results and extmarks
nnoremap("<CR>", function()
	vim.cmd.nohlsearch()
	vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
end, { silent = true })

--- delete all marks
nnoremap("mx", function()
	vim.cmd.delm({ bang = true })
	vim.cmd.delm("A-Z0-9")
	vim.cmd.delm('"<>')
	vim.cmd.wshada({ bang = true })
end, { desc = "delete all marks" })

--- escape terminal mode
tnoremap("qq", "<C-\\><C-n>")

----------------------------------
--- definition of new commands ---
----------------------------------
vim.api.nvim_create_user_command("Rf", function()
	require("functions").replace_file()
end, {})

vim.api.nvim_create_user_command("W", function()
	vim.cmd.write()
end, {})
vim.api.nvim_create_user_command("Q", function()
	vim.cmd.quit()
end, {})
