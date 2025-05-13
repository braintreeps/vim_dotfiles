-- LSP: configure the Language Server Protocol (LSP) client.

local LazyFileEvents = require("lazy_utils").LazyFileEvents
local lsp_servers = require("lsp_config").default_lsp_servers

return {
    {
        "neovim/nvim-lspconfig",
        event = LazyFileEvents,
        dependencies = {
            {
                "j-hui/fidget.nvim",
                opts = {
                    notification = {
                        window = {
                            winblend = 0, -- transparent background
                        },
                    },
                },
            },
        },
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = "Mason",
        tag = "v1.11.0",
        opts = {},
        keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
        },
        config = function(_, opts)
            require("mason").setup(opts)
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        tag = "v1.32.0",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            automatic_installation = true,
            ensure_installed = lsp_servers,
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "lazy.nvim", words = { "LazyVim" } },
            },
        },
    },
}
