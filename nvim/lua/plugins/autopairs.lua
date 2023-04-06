local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
	return
end

local Rule = require("nvim-autopairs.rule")

npairs.setup({
	ignored_next_char = "[%w%.]",
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

npairs.add_rule(Rule("<", ">"))
