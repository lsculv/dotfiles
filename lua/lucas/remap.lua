vim.g.mapleader = " "
vim.keymap.set("n", "<leader>jq", vim.cmd.Ex) 
vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover)
vim.keymap.set("n", "<F9>", ":!%:p<CR>")
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader><leader>", "<C-^>")

-- Formatting current file/project
local filetypes = {
    rust = ":!cargo fmt",
    ocaml = ":!dune fmt",
    go = ":!go fmt",
    python = ":!black %"
}

function Format()
    local filetype = vim.bo.filetype
    local command = filetypes[filetype]
    if command then
        vim.cmd(command)
    else
        print("Error: No formatting command defined for this file type.")
    end

    return cmd
end

vim.api.nvim_set_keymap("n", "<leader>fm", "<Cmd>lua Format()<Cr>", { silent = false } )

