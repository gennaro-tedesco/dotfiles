require("bqf").setup({ func_map = { openc = "<CR>" } })
require("pqf").setup({
	signs = { error = "✘", warning = ".", info = "i", hint = "💡" },
})
require("nvim-jqx.config").use_quickfix = false
