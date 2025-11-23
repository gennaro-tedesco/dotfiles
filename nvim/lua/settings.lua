vim.opt.background = "dark"

--- cursorline, windows frame and looks
vim.opt.showtabline = 1
vim.opt.showbreak = "↪"
vim.opt.list = true
vim.opt.listchars = { tab = "  ", nbsp = "␣", trail = "•", extends = "⟩", precedes = "⟨" }
vim.opt.fillchars = { eob = " ", diff = " ", fold = " " }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 1
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.showmode = false
vim.opt.signcolumn = "number"
vim.opt.startofline = true
vim.o.winborder = "rounded"

--- standard neovim behavior
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.updatetime = 100
vim.opt.sidescroll = 1
vim.opt.clipboard:append({ "unnamed" })
vim.opt.autoindent = true
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

--- diff options
vim.g.diffopt = { context = 3, linematch = 60 }

--- search options
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
local git_root = require("utils").git_root() or ""
vim.opt.grepprg = "rg --vimgrep " .. git_root .. " -e"
vim.opt.grepformat = "%f:%l:%c:%m"

--- autocompletion options
vim.o.shortmess = vim.o.shortmess .. "csW"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full", "list" }
vim.opt.wildcharm = ("\t"):byte()
vim.opt.pumheight = 10

--- matching pairs
vim.opt.matchpairs:append({ "<:>" })

--- language specific global settings
vim.g.python3_host_prog = "/usr/local/bin/python3"
vim.g.no_python_maps = 1
vim.g.no_rust_maps = 1

--------------------
--- autocommands ---
--------------------
local general_settings = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = general_settings,
	pattern = { "*" },
	desc = "remove formatoptions",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = general_settings,
	desc = "highlight yank",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = general_settings,
	desc = "settings for terminal windows",
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = general_settings,
	desc = "remember last cursor place",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = general_settings,
	pattern = { "[^l]*" },
	command = "cwindow",
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = general_settings,
	desc = "always cd into root directory",
	callback = function(ctx)
		local root = vim.fs.root(ctx.buf, { ".git", "Makefile" })
		if root then
			vim.cmd.lcd(root)
		end
	end,
})

local toggle_options = vim.api.nvim_create_augroup("ToggleOptions", { clear = true })

vim.api.nvim_create_autocmd("WinLeave", {
	group = toggle_options,
	desc = "unset cursorline",
	command = "lua vim.opt.cursorline = false",
})

vim.api.nvim_create_autocmd("WinEnter", {
	group = toggle_options,
	desc = "set cursorline",
	command = "lua vim.opt.cursorline = true",
})

vim.api.nvim_create_autocmd("User", {
	desc = "Cleanup on exit",
	pattern = "VimtexEventQuit",
	group = vim.api.nvim_create_augroup("init_vimtex", {}),
	command = "VimtexClean",
})

local vim_enter_cmd = vim.api.nvim_create_augroup("VimEnterCmd", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim_enter_cmd,
	desc = "open nvim-tree on directory enter",
	callback = function(data)
		local directory = vim.fn.isdirectory(data.file) == 1
		if not directory then
			return
		end
		vim.cmd.cd(data.file)
		require("nvim-tree.api").tree.open()
	end,
})

---------------
--- folding ---
---------------
---@param line string
---@param lnum number
local function fold_virt_text(line, lnum)
	local text = ""
	local hl
	local result = {}
	for i = 1, #line do
		local char = line:sub(i, i)
		local hls = vim.treesitter.get_captures_at_pos(0, lnum, i - 1)
		if next(hls) ~= nil then
			local new_hl = "@" .. hls[#hls].capture
			if new_hl ~= hl then
				table.insert(result, { text, hl })
				text = ""
				hl = nil
			end
			text = text .. char
			hl = new_hl
		else
			text = text .. char
		end
	end
	table.insert(result, { text, hl })
	return result
end

function _G.fold_text()
	local line = vim.fn.getline(vim.v.foldstart)
	local count = vim.v.foldend - vim.v.foldstart + 1
	local icon = "▼"

	local result = fold_virt_text(line, vim.v.foldstart - 1)
	table.insert(result, { " … " .. icon .. count, "Folded" })
	return result
end

vim.opt.foldtext = "v:lua.fold_text()"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
