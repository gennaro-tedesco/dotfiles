local ok_to, to = pcall(require, "nvim-treesitter-textobjects")
if ok_to then
	to.setup({
		select = {
			lookahead = true,
		},
		move = {
			set_jumps = true,
		},
	})

	local sel = require("nvim-treesitter-textobjects.select")
	local mov = require("nvim-treesitter-textobjects.move")

	vim.keymap.set({ "x", "o" }, "af", function()
		sel.select_textobject("@function.outer", "textobjects")
	end, { desc = "🌲select around function" })

	vim.keymap.set({ "x", "o" }, "if", function()
		sel.select_textobject("@function.inner", "textobjects")
	end, { desc = "🌲select inside function" })

	vim.keymap.set({ "x", "o" }, "aC", function()
		sel.select_textobject("@class.outer", "textobjects")
	end, { desc = "🌲select around class" })

	vim.keymap.set({ "x", "o" }, "iC", function()
		sel.select_textobject("@class.inner", "textobjects")
	end, { desc = "🌲select inside class" })

	vim.keymap.set({ "x", "o" }, "al", function()
		sel.select_textobject("@loop.outer", "textobjects")
	end, { desc = "🌲select around loop" })

	vim.keymap.set({ "x", "o" }, "il", function()
		sel.select_textobject("@loop.inner", "textobjects")
	end, { desc = "🌲select inside loop" })

	vim.keymap.set({ "x", "o" }, "ab", function()
		sel.select_textobject("@block.outer", "textobjects")
	end, { desc = "🌲select around block" })

	vim.keymap.set({ "x", "o" }, "ib", function()
		sel.select_textobject("@block.inner", "textobjects")
	end, { desc = "🌲select inside block" })

	vim.keymap.set({ "x", "o" }, "ac", function()
		sel.select_textobject("@conditional.outer", "textobjects")
	end, { desc = "🌲select around conditional" })

	vim.keymap.set({ "x", "o" }, "ic", function()
		sel.select_textobject("@conditional.inner", "textobjects")
	end, { desc = "🌲select inside conditional" })

	vim.keymap.set({ "n", "x", "o" }, "g+", function()
		mov.goto_next_start("@function.outer", "textobjects")
	end, { desc = "🌲go to next function" })

	vim.keymap.set({ "n", "x", "o" }, "gC+", function()
		mov.goto_next_start("@class.outer", "textobjects")
	end, { desc = "🌲go to next class" })

	vim.keymap.set({ "n", "x", "o" }, "gl+", function()
		mov.goto_next_start("@loop.outer", "textobjects")
	end, { desc = "🌲go to next loop" })

	vim.keymap.set({ "n", "x", "o" }, "gb+", function()
		mov.goto_next_start("@block.outer", "textobjects")
	end, { desc = "🌲go to next block" })

	vim.keymap.set({ "n", "x", "o" }, "g-", function()
		mov.goto_previous_start("@function.outer", "textobjects")
	end, { desc = "🌲go to previous function" })

	vim.keymap.set({ "n", "x", "o" }, "gC-", function()
		mov.goto_previous_start("@class.outer", "textobjects")
	end, { desc = "🌲go to previous class" })

	vim.keymap.set({ "n", "x", "o" }, "gl-", function()
		mov.goto_previous_start("@loop.outer", "textobjects")
	end, { desc = "🌲go to previous loop" })

	vim.keymap.set({ "n", "x", "o" }, "gb-", function()
		mov.goto_previous_start("@block.outer", "textobjects")
	end, { desc = "🌲go to previous block" })
end
