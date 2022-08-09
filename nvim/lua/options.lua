require'nvim-treesitter.configs'.setup {
    highlight = {enable = true},
    ensure_installed = {"go", "python", "json", "lua", "bash", "yaml"}
}

require('neoscroll').setup()

require('bqf').setup({func_map = {openc = '<CR>'}})

require('nvim-jqx.config').use_quickfix = false

require('git-conflict').setup({
    default_mappings = true,
    highlights = {incoming = 'DiffText', current = 'DiffAdd'}
})
vim.keymap.set('n', '++', '<Plug>(git-conflict-next-conflict)')
vim.keymap.set('n', '--', '<Plug>(git-conflict-prev-conflict)')
vim.keymap.set('n', 'cq', ':GitConflictListQf<CR>')

require('pqf').setup({
    signs = {error = '✘', warning = 'W', info = 'I', hint = 'H'}
})

