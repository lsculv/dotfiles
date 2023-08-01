local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"rust_analyzer",
	"pyright"
})

lsp.on_attach(function(client, buff)
    local opts = { buffer = buff, remap = false}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format() end, opts)
    client.server_capabilities.semanticTokensProvider = nil
end)

lsp.setup()

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
})

