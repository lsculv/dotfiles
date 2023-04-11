vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.termguicolors = true

vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.colorcolumn = "80"

vim.opt.updatetime = 50

-- Configurations for colorschemes that don't support the 0.9 semantic highlights
--local links = {
--  ['@lsp.type.namespace'] = '@namespace',
--  ['@lsp.type.type'] = '@type',
--  ['@lsp.type.class'] = '@type',
--  ['@lsp.type.enum'] = '@type',
--  ['@lsp.type.interface'] = '@type',
--  ['@lsp.type.struct'] = '@structure',
--  ['@lsp.type.parameter'] = '@parameter',
--  ['@lsp.type.variable'] = '@variable',
--  ['@lsp.type.property'] = '@property',
--  ['@lsp.type.enumMember'] = '@constant',
--  ['@lsp.type.function'] = '@function',
--  ['@lsp.type.method'] = '@method',
--  ['@lsp.type.macro'] = '@macro',
--  ['@lsp.type.decorator'] = '@function',
--}
--for newgroup, oldgroup in pairs(links) do
--  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
--end
--
--

