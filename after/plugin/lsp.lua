local lsp = require("lsp-zero")

local lua_opts = lsp.nvim_lua_ls()
require('lspconfig').lua_ls.setup(lua_opts)

require("mason").setup()
require('mason-lspconfig').setup({
    handlers = {
        lsp.default_setup,
    }
})

local cmp = require('cmp')
local cmp_action = lsp.cmp_action()
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    window = {
    documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ['<CR>'] = cmp.mapping.confirm({select = false}),

        -- toggle completion menu
        ['<C-e>'] = cmp_action.toggle_completion(),

        -- tab complete
        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- navigate between snippet placeholder
        ['<C-d>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),

        -- scroll documentation window
        ['<C-f>'] = cmp.mapping.scroll_docs(-5),
        ['<C-u>'] = cmp.mapping.scroll_docs(5),
    }),
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
  },
})

lsp.preset("recommended")

lsp.on_attach(function(client, buff)
    local opts = { buffer = buff, remap = false}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>aa", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>ee", function() vim.diagnostic.setqflist() end, opts)
    client.server_capabilities.semanticTokensProvider = nil
end)

lsp.setup()

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
})

