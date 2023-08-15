--vim.o.background = "dark"

require("github-theme").setup({
    keyword_style = "bold",
    comment_style = "none",

})

vim.g.lightline = { colorscheme = "deus" }

vim.cmd('autocmd FileType markdown setlocal spell')
vim.cmd('autocmd FileType gitcommit setlocal spell')


--require("gruvbox").setup({
	--italic = false,
--})
--vim.cmd([[colorscheme gruvbox]])
