local ok, blink = pcall(require, "blink.cmp")
if not ok then
	return
end

local icons = require("utils").icons

---@module 'blink.cmp'
---@type blink.cmp.Config
blink.setup({
	sources = {
		default = { "lsp", "path", "luasnip", "buffer" },
		-- cmdline = {},
		providers = {
			luasnip = {
				min_keyword_length = 2,
				score_offset = 4,
			},
			lsp = {
				min_keyword_length = 3,
				score_offset = 3,
			},
			path = {
				min_keyword_length = 3,
				score_offset = 2,
			},
			buffer = {
				min_keyword_length = 5,
				score_offset = 1,
			},
		},
	},
	completion = {
		list = {
			max_items = 10,
			selection = function(ctx)
				return ctx.mode == "cmdline" and "auto_insert" or "preselect"
			end,
		},
		menu = {
			auto_show = true,
			border = "rounded",
			draw = {
				columns = {
					{ "kind_icon", "label", gap = 1 },
					{ "source_name" },
				},
				components = {
					source_name = {
						width = { max = 30 },
						text = function(ctx)
							return icons.cmp_sources[ctx.source_name]
						end,
						highlight = "BlinkCmpSource",
					},
				},
			},
			winhighlight = "Normal:Normal,FloatBorder:Todo,CursorLine:CursorLine,Search:None,BlinkCmpLabelMatch:Todo",
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 100,
			window = {
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:Todo,CursorLine:CursorLine,Search:None",
			},
		},
		accept = { auto_brackets = { enabled = true } },
	},
	fuzzy = {
		use_typo_resistance = false,
	},
	keymap = {
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<C-k>"] = { "scroll_documentation_up", "fallback" },
		["<C-j>"] = { "scroll_documentation_down", "fallback" },
		["<C-e>"] = { "cancel" },
		["K"] = { "show", "show_documentation", "hide_documentation" },
		cmdline = {
			["<cr>"] = {
				function(cmp)
					return cmp.accept({
						callback = function()
							vim.api.nvim_feedkeys("\n", "n", true)
						end,
					})
				end,
				"fallback",
			},
			["<Tab>"] = { "select_next" },
			["<S-Tab>"] = { "select_prev" },
			["<C-e>"] = { "cancel" },
		},
	},
	appearance = {
		kind_icons = icons.kinds,
	},
	signature = {
		enabled = true,
		window = {
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:Todo,CursorLine:CursorLine,Search:None",
		},
	},
})
