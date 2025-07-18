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

--- redo
nnoremap("U", "<C-r>")

--- remove all trailing spaces
nnoremap("<F5>", "<cmd>lua require('utils').trim_whitespace()<CR>")

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
vim.keymap.set({ "n", "v", "o" }, "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true })
vim.keymap.set({ "n", "v", "o" }, "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true })
vim.keymap.set({ "n", "v", "o" }, "<Down>", function()
	return vim.v.count == 0 and "gj" or "<Down>"
end, { expr = true })
vim.keymap.set({ "n", "v", "o" }, "<Up>", function()
	return vim.v.count == 0 and "gk" or "<Up>"
end, { expr = true })
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
nnoremap("<PageUp>", "{")
nnoremap("<PageDown>", "}")
vnoremap("<PageUp>", "{")
vnoremap("<PageDown>", "}")
nnoremap("<Tab>", "<C-w>w")
vnoremap("<Tab>", "<C-w>w")
nnoremap("<S-Tab>", "<C-w>W")
vnoremap("<S-Tab>", "<C-w>W")

--- project search
nnoremap("<C-h>", require("utils").project_search, { desc = "project search" })
--- open buffers search
nnoremap("<C-j>", require("utils").buffers_search, { desc = "search in open buffers only" })

--- close all splits/windows except the one in focus
nnoremap("<leader>q", "<C-w>o", { desc = "close all windows except the focussed one" })

--- avoid x and s to override the clipboard
nnoremap("x", '"_x')
nnoremap("s", '"_s')
nnoremap("X", '"_X')

--- replace a word with yanked text
nnoremap("rw", "viwpyiw", { desc = "replace a word with yanked text" })

--- replace till the end of line with yanked text
nnoremap("rl", 'Pl"_D', { desc = "replace till end of the line" })

--- ciw
nnoremap("S", "ciw")

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
nnoremap("*", "*<cmd>lua require('utils').count_matches()<CR>nN", { desc = "count matches for word under cursor" })

--- blink word under cursor in search mode
nnoremap("n", "nzz<cmd>lua require('utils').hl_search(0.3)<CR>", { desc = "go to next search and highlight" })
nnoremap("N", "Nzz<cmd>lua require('utils').hl_search(0.3)<CR>", { desc = "go to prev search and highlight" })

--- quickfix
nnoremap("<C-q>", "<cmd> lua require('utils').toggle_qf()<CR>", { desc = "toggle quickfix" })
nnoremap("<C-l>", "<cmd> lua require('utils').toggle_ll()<CR>", { desc = "toggle loc list" })
nnoremap("<leader><C-o>", "<cmd> lua require('utils').jumps_to_qf()<CR>", { desc = "send jumplist to quickfix" })

--- open todo file in one go
nnoremap("<C-t>", function()
	vim.cmd.edit(vim.fs.normalize("~/.todo"))
end, { desc = "open todo file" })

--- clean up search results and extmarks
nnoremap("<CR>", function()
	vim.cmd.nohlsearch()
	local search_ns = vim.api.nvim_get_namespaces().search
	if search_ns ~= nil then
		vim.api.nvim_buf_clear_namespace(0, search_ns, 0, -1)
	end
end, { silent = true, desc = "clean up search results and extmarks" })

--- delete all marks
nnoremap("mx", function()
	vim.cmd.delm({ bang = true })
	vim.cmd.delm("A-Z0-9")
	vim.cmd.delm('"<>')
	vim.cmd.wshada({ bang = true })
end, { desc = "delete all marks" })

--- make bullet point
nnoremap("<leader>p", ":Bullet<CR>", { desc = "add bullet to current line" })
vnoremap("<leader>p", ":Bullet<CR>", { desc = "add bullets to selected lines" })

--- escape terminal mode
tnoremap("<C-q>", "<C-\\><C-n>")

----------------------------------
--- definition of new commands ---
----------------------------------
vim.api.nvim_create_user_command("Rf", function()
	require("utils").replace_file()
end, {})

vim.api.nvim_create_user_command("W", function()
	vim.cmd.write()
end, {})

vim.api.nvim_create_user_command("Q", function()
	vim.cmd.quit()
end, {})

vim.api.nvim_create_user_command("ToSql", function()
	vim.api.nvim_exec2("g/^$/d", { output = true })
	vim.api.nvim_exec2("%s/^/'/", {})
	vim.api.nvim_exec2("%s/$/',/", {})
	vim.api.nvim_exec2("%s/\\%^/(/", {})
	vim.api.nvim_exec2("%s/,\\%$/)/", {})
end, {})

vim.api.nvim_create_user_command("Gbrowse", function()
	require("utils").gbrowse()
end, {})

vim.api.nvim_create_user_command("Bullet", function(opts)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if opts.range == 0 then
		vim.cmd("normal! I- ")
	else
		vim.cmd(string.format("%d,%ds/^/- /", opts.line1, opts.line2))
	end
	cursor_pos[2] = cursor_pos[2] + 2
	vim.api.nvim_win_set_cursor(0, cursor_pos)
	vim.cmd.nohlsearch()
end, { range = true })
