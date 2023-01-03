local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local pairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not pairs_ok then
	return
end

cmp.setup({
	view = {
		entries = { name = "custom", selection_order = "near_cursor" },
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		documentation = cmp.config.window.bordered(),
		completion = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = function(entry, item)
			item.kind = string.format("%s %s", icons[item.kind], item.kind)
			item.menu = ({
				nvim_lsp = "✨",
				luasnip = "🚀",
				buffer = "📝",
				path = "📁",
			})[entry.source.name]
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
		{ name = "buffer", keyword_length = 5 },
		{ name = "path" },
	},
	sorting = {
		comparators = {
			cmp.config.compare.exact,
			cmp.config.compare.recently_used,
		},
	},
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	formatting = { fields = { "abbr" } },
	sources = {
		{ name = "nvim_lsp_document_symbol" },
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
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
	"Constant",
	"Constructor",
	"Field",
	"Function",
	"Keyword",
	"Method",
	"Operator",
	"Property",
	"Text",
}

vim.api.nvim_clear_autocmds({ group = cmp_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = cmp_hl,
	desc = "redefinition of nvim-cmp highlight groups",
	callback = function()
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", {})
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "helpVim" })
		vim.api.nvim_set_hl(0, "CmpItemKindVariable", {})
		vim.api.nvim_set_hl(0, "CmpItemKindVariable", { link = "@number" })
		for _, type in ipairs(cmp_types) do
			vim.api.nvim_set_hl(0, "CmpItemKind" .. type, {})
			vim.api.nvim_set_hl(0, "CmpItemKind" .. type, { link = "@" .. type })
		end
	end,
})
