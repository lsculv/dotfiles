require("lucas.remap")
require("lucas.opts")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')
            configs.setup({
                ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'python', 'rust' },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x'
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'L3MON4D3/LuaSnip' },

    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        priority = 1000,
    },

    { 'itchyny/lightline.vim' },

}

local opts = {} -- Unused

require("lazy").setup(plugins, opts)
