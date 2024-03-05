-- Aesthetic options
vim.o.background = 'dark'
vim.opt.termguicolors = true

-- Leader and remaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader>jq', vim.cmd.Ex)
vim.keymap.set('n', '<leader><leader>', '<C-^>')
vim.keymap.set('n', '<leader>m', vim.cmd.Man)

-- Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Horizontal wrapping and ruler
vim.opt.wrap = false
vim.opt.colorcolumn = '80'

-- Indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Scrolling
vim.opt.scrolloff = 8

-- Mouse handling
vim.opt.mouse = 'a'

-- Lowering the default update time
vim.opt.updatetime = 250

-- Using an external status line plugin
vim.opt.showmode = false

-- Undo options
vim.opt.undofile = true

-- Signs (usually from the LSP)
vim.opt.signcolumn = 'yes'

-- White space handling
vim.opt.list = true
vim.opt.listchars = { trail = '·', nbsp = '␣' }

-- In-buffer searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Spell checking
vim.opt.spell = true
vim.cmd('autocmd FileType markdown setlocal spell')
vim.cmd('autocmd FileType gitcommit setlocal spell')

-- Enable text highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight on yank',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Ensure Lazy.nvim is installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- Comment and uncomment lines
    { 'numToStr/Comment.nvim', opts = {} },
    -- Code and file search
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
        end,
    },
    -- Treesitter support
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')
            configs.setup({
                ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'python', 'rust' },
                ignore_install = {},
                auto_install = false,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    -- LSP setup
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func)
                        vim.keymap.set('n', keys, func, { buffer = event.buf })
                    end
                    -- Telescope will provide fuzzy finding if multiple possible
                    -- definitions, etc. are found. Could also use the `vim.lsp`
                    -- versions instead.
                    map('gd', require('telescope.builtin').lsp_definitions)
                    map('gD', vim.lsp.buf.declaration)
                    map('gr', require('telescope.builtin').lsp_references)
                    map('gI', require('telescope.builtin').lsp_implementations)
                    map('<C-k>', vim.lsp.buf.hover)
                    map('<leader>fs', require('telescope.builtin').lsp_dynamic_workspace_symbols)
                    map('<leader>rn', vim.lsp.buf.rename)
                    map('<leader>ee', vim.diagnostic.setqflist)
                    map('<leader>aa', vim.lsp.buf.code_action)
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                -- Manually configure Lua because it is the config language so it needs some special care.
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT' },
                            workspace = {
                                checkThirdParty = false,
                                -- Tells the LSP where our loaded neovim config files are.
                                library = {
                                    '${3rd}/luv/library',
                                    unpack(vim.api.nvim_get_runtime_file('', true)),
                                },
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
                clangd = {
                    cmd = { vim.fn.stdpath('data') .. '/mason/bin/clangd', '--enable-config' },
                    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
                    root_dir = function(file_name)
                        return require('lspconfig.util').find_git_ancestor(file_name)
                    end,
                },
            }

            -- Mason LSP package manager
            require('mason').setup()
            require('mason-lspconfig').setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    -- Auto complete
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                build = 'make install_jsregexp',
            },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
            })
        end,
    },

    -- Auto format
    {
        'stevearc/conform.nvim',
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                -- This is broken right now and inserts a bunch of
                -- ^I indention characters.
                lua = { 'stylua' },
                python = { 'ruff_format' },
            },
        },
    },

    -- Auto matching paired characters
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    -- Color scheme
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        priority = 1000,
        config = function()
            require('rose-pine').setup({
                styles = {
                    italic = false,
                },
            })
            vim.cmd.colorscheme('rose-pine-moon')
        end,
    },

    -- Status line plugin
    {
        'itchyny/lightline.vim',
        config = function()
            vim.g.lightline = { colorscheme = 'rosepine_moon' }
        end,
    },
}

-- Unused
local opts = {}

require('lazy').setup(plugins, opts)
