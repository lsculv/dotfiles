vim.o.background = "dark"

vim.g.lightline = { colorscheme = 'rosepine_moon' }

require('rose-pine').setup({
    disable_italics = true,
})

vim.cmd('colorscheme rose-pine-moon')

vim.cmd('autocmd FileType markdown setlocal spell')
vim.cmd('autocmd FileType gitcommit setlocal spell')
