local npairs = require("nvim-autopairs")
npairs.setup({
	ignored_next_char = "[%w%.]",
})
npairs.setup({
	fast_wrap = {},
})
npairs.setup({
	fast_wrap = {
		map = "<C-w>",
		chars = { "{", "[", "(", '"', "'" },
		pattern = [=[[%'%"%)%>%]%)%}%,]]=],
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
	},
})
