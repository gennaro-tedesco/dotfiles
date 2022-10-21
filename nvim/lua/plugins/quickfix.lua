local bqf_ok, bqf = pcall(require, "bqf")
if not bqf_ok then
	return
end

local pqf_ok, pqf = pcall(require, "nvim-pqf")
if not pqf_ok then
	return
end

local jqx_ok, _ = pcall(require, "nvim-jqx")
if not jqx_ok then
	return
end

bqf.setup({ func_map = { openc = "<CR>" } })
pqf.setup({
	signs = { error = "✘", warning = ".", info = "i", hint = "💡" },
})
require("nvim-jqx.config").use_quickfix = false
