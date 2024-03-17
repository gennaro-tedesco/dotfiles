local ok, flash = pcall(require, "flash")
if not ok then
	return
end

local ts_exclude = {
	"comment",
	"identifier",
	"keyword",
	"conditional",
	"variable",
	"number",
	"dot_index_expression",
	"field_expression",
	"field_identifier",
	"attribute",
}

flash.setup({
	label = { min_pattern_length = 3, style = "eol" },
	highlight = { groups = { backdrop = "SignColumn" } },
	modes = {
		char = {
			config = function(opts)
				opts.autohide = vim.fn.mode(true):find("no") and (vim.v.operator == "y" or vim.v.operator == "d")
			end,
			search = { wrap = true },
			highlight = {
				backdrop = false,
				groups = {
					label = "Search",
					match = "Search",
				},
			},
			multi_line = false,
		},
		search = { highlight = { groups = { label = "Todo" } } },
		treesitter = {
			filter = function(matches)
				return vim.tbl_filter(function(m)
					return not (m.node and vim.tbl_contains(ts_exclude, m.node:type()))
				end, matches)
			end,
			label = {
				before = true,
				after = true,
				style = "overlay",
				rainbow = { enabled = true, shade = 5 },
				highlight = {
					backdrop = false,
					matches = false,
				},
			},
		},
	},
})
