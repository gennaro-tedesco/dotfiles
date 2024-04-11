local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local pairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not pairs_ok then
	return
end

local icons = require("utils").icons

cmp.setup({
	view = {
		entries = { name = "custom", selection_order = "near_cursor", follow_cursor = true },
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		documentation = cmp.config.window.bordered({ winhighlight = "FloatBorder:Todo" }),
		completion = cmp.config.window.bordered({ col_offset = -3, winhighlight = "FloatBorder:Todo" }),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, item)
			local kind = string.lower(item.kind)
			item.kind = icons.kinds[item.kind] or "?"
			item.abbr = item.abbr:match("[^(]+")
			item.menu = (icons.cmp_sources[entry.source.name] or "") .. kind
			return item
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping.scroll_docs(-4),
		["<C-j>"] = cmp.mapping.scroll_docs(4),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),
		["<C-e>"] = cmp.mapping.abort(),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = "luasnip", keyword_length = 2 },
		{ name = "nvim_lsp", keyword_length = 3 },
		{
			name = "buffer",
			keyword_length = 5,
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
		{ name = "path" },
	},
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			require("cmp-under-comparator").under,
			cmp.config.compare.kind,
		},
	},
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	window = { completion = cmp.config.window.bordered({ col_offset = 0 }) },
	formatting = { fields = { "abbr" } },
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	window = { completion = cmp.config.window.bordered({ col_offset = 0 }) },
	formatting = { fields = { "abbr" } },
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

local cmp_hl = vim.api.nvim_create_augroup("CmpHighlights", {})
local cmp_types = {
	"Class",
	"Constant",
	"Constructor",
	"Enum",
	"Field",
	"Function",
	"Keyword",
	"Method",
	"Operator",
	"Property",
	"Struct",
	"Text",
}

vim.api.nvim_clear_autocmds({ group = cmp_hl })
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	group = cmp_hl,
	desc = "redefinition of nvim-cmp highlight groups",
	callback = function()
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", {})
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "@text.todo" })
		vim.api.nvim_set_hl(0, "CmpItemMenu", {})
		vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "LineNr" })
		vim.api.nvim_set_hl(0, "CmpItemKindVariable", {})
		vim.api.nvim_set_hl(0, "CmpItemKindVariable", { link = "@number" })
		for _, type in ipairs(cmp_types) do
			vim.api.nvim_set_hl(0, "CmpItemKind" .. type, {})
			vim.api.nvim_set_hl(0, "CmpItemKind" .. type, { link = "@" .. type })
		end
	end,
})
