local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

local builtin = require("fzf-lua.previewer.builtin")
local EnvPreviewer = builtin.base:extend()

function EnvPreviewer:new(o, opts, fzf_win)
	EnvPreviewer.super.new(self, o, opts, fzf_win)
	setmetatable(self, EnvPreviewer)
	return self
end

function EnvPreviewer:populate_preview_buf(entry_str)
	local tmpbuf = self:get_tmp_buffer()
	local entry = vim.system({ "printenv", entry_str }, { text = true }):wait().stdout:gsub("[\n\r]", " ")
	vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, {
		" " .. entry,
	})
	self:set_preview_buf(tmpbuf)
	self.win:update_preview_scrollbar()
end

function EnvPreviewer:gen_winopts()
	local new_winopts = {
		wrap = true,
		number = false,
	}
	return vim.tbl_extend("force", self.winopts, new_winopts)
end

--- custom fzf pickers
local M = {}

M.printenv = function()
	local cmd = "printenv | cut -d= -f1"
	local opts = {
		prompt = ":",
		previewer = EnvPreviewer,
		hls = { cursorline = "" },
		winopts = {
			title = " env variables ",
			title_pos = "center",
			height = 0.4,
			preview = {
				hidden = "nohidden",
				horizontal = "down:10%",
			},
		},
		actions = {
			["default"] = function(selected)
				vim.notify(
					vim.system({ "printenv", selected[1] }, { text = true }):wait().stdout:gsub("[\n\r]", " "),
					vim.log.levels.INFO,
					{ ft = "bash" }
				)
			end,
		},
	}
	fzf.fzf_exec(cmd, opts)
end

M.filter_qf = function()
	local qf_tbl = vim.fn.getqflist()
	local hash = {}
	local qf_files = {}
	for _, qf_item in ipairs(qf_tbl) do
		if not hash[qf_item["bufnr"]] then
			qf_files[#qf_files + 1] = vim.fn.bufname(qf_item["bufnr"])
			hash[qf_item["bufnr"]] = true
		end
	end

	if #qf_files <= 1 then
		return
	end

	local new_qf = {}
	local opts = {
		winopts = {
			title = " filter quickfix ",
			title_pos = "center",
			row = -1,
			height = 0.2,
		},
		fzf_opts = {
			["--multi"] = true,
		},
		actions = {
			["default"] = function(selected)
				for _, selection in ipairs(selected) do
					for _, qf_item in ipairs(qf_tbl) do
						if vim.fn.bufname(qf_item["bufnr"]) == selection then
							table.insert(new_qf, qf_item)
						end
					end
				end
				vim.fn.setqflist(new_qf, " ")
				vim.cmd.copen()
			end,
		},
	}
	fzf.fzf_exec(qf_files, opts)
end

return M
