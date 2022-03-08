require'nvim-treesitter.configs'.setup {
    highlight = {enable = true},
    ensure_installed = {"go", "python", "json", "lua", "bash", "yaml"}
}

require('neoscroll').setup()

require('bqf').setup({func_map = {openc = '<CR>'}})

require('nvim-jqx.config').use_quickfix = false
