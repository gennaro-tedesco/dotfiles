vim.opt.background = "dark"

--- cursorline, windows frame and looks
vim.opt.showtabline = 0
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
vim.opt.signcolumn = "number"

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
vim.opt.grepprg = "rg --vimgrep " .. require("utils").git_root() .. " -e"
vim.opt.grepformat = "%f:%l:%c:%m"

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

vim.api.nvim_create_autocmd("VimEnter", {
	group = general_settings,
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

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = general_settings,
	pattern = { "[^l]*" },
	command = "cwindow",
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
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
		vim.api.nvim_set_hl(0, "WinBarNC", { link = "WinBar" })
		vim.api.nvim_set_hl(0, "CursorLine", { link = "CursorColumn" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "Constant" })
		vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
		vim.api.nvim_set_hl(0, "ErrorMsg", { bold = false, fg = "#dc322f", bg = "none" })
		vim.api.nvim_set_hl(0, "DiagnosticOk", { bold = false, ctermfg = 1, fg = "LightGreen" })
		vim.api.nvim_set_hl(0, "DiagnosticSignOk", { link = "DiagnosticOk" })
		vim.api.nvim_set_hl(0, "DiagnosticError", { bold = false, ctermfg = 1, fg = "Red" })
		vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
		vim.api.nvim_set_hl(0, "DiagnosticWarn", { bold = false, ctermfg = 1, fg = "Orange" })
		vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { link = "DiagnosticWarn" })
		vim.api.nvim_set_hl(0, "DiffDelete", { bold = true, ctermfg = 12, ctermbg = 6, fg = "#dc322f", bg = "none" })
		vim.api.nvim_set_hl(0, "DiffChange", { bold = true, ctermbg = 5, fg = "#b58900", bg = "none", sp = "#b58900" })
		vim.api.nvim_set_hl(0, "WinSeparator", { bold = false, fg = "#268bd2", bg = "none" })
	end,
})
