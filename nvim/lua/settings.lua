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
vim.opt.diffopt = { context = 3, linematch = 60 }

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
		vim.api.nvim_set_hl(0, "WinSeparator", { bold = false, fg = "#268bd2", bg = "none" })
	end,
})
