vim.g.mapleader = " "
vim.keymap.set("n", "<leader>jq", vim.cmd.Ex) 
vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover)
vim.keymap.set("n", "<F9>", ":!%:p<CR>")
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader><leader>", "<C-^>")
