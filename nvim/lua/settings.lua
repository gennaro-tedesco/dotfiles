vim.opt.background = "dark"

--- cursorline, windows frame and looks
vim.opt.showbreak = "↪"
vim.opt.list = true
vim.opt.listchars = { tab = "  ", nbsp = "␣", trail = "•", extends = "⟩", precedes = "⟨" }
vim.opt.fillchars = { eob = " " }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.showmode = false

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

--- autocompletion options
vim.o.shortmess = vim.o.shortmess .. "c"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full", "list" }
vim.opt.wildcharm = ("\t"):byte()
vim.opt.pumheight = 10

--- matching pairs
vim.opt.matchpairs:append({ "<:>" })

--- python host programme
vim.g.python3_host_prog = "/usr/local/bin/python3"

--------------------
--- autocommands ---
--------------------
local format = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_clear_autocmds({ group = format })
vim.api.nvim_create_autocmd("FileType", {
	group = format,
	pattern = { "*" },
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

local highlight_yank = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_clear_autocmds({ group = highlight_yank })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank,
	desc = "highlight yank",
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
	end,
})

local terminal_open = vim.api.nvim_create_augroup("TerminalOpen", {})
vim.api.nvim_clear_autocmds({ group = terminal_open })
vim.api.nvim_create_autocmd("TermOpen", {
	group = terminal_open,
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = lastplace,
	pattern = { "*" },
	desc = "remember last cursor place",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

------------------------
--- highlight groups ---
------------------------
local hl = vim.api.nvim_create_augroup("Highlights", {})
vim.api.nvim_clear_autocmds({ group = hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = hl,
	pattern = { "*" },
	desc = "redefinition of default highlight groups",
	callback = function()
		vim.api.nvim_set_hl(0, "ErrorMsg", { bold = false, fg = "#dc322f", bg = "none" })
		vim.api.nvim_set_hl(0, "DiffDelete", { bold = true, ctermfg = 12, ctermbg = 6, fg = "#dc322f", bg = "none" })
		vim.api.nvim_set_hl(0, "DiffChange", { bold = true, ctermbg = 5, fg = "#b58900", bg = "none", sp = "#b58900" })
		vim.api.nvim_set_hl(0, "WinSeparator", { bold = false, fg = "#268bd2", bg = "none" })
	end,
})
