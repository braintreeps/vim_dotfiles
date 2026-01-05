-- Coding: Faster coding with features such as snippets, autocompletion, and more.

local Utils = require("config.utils")
local LazyFileEvents = Utils.lazy.LazyFileEvents

return {
    {
        "windwp/nvim-autopairs",
        enabled = false, -- Toggle this in neovim-dotfiles-personal to turn on autopairs
        event = "InsertEnter",
    },
    {
        "numToStr/Comment.nvim",
        event = LazyFileEvents,
        opts = {},
    },
    {
        "saghen/blink.cmp",
        version = "*",
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
        dependencies = {
            "mgalliou/blink-cmp-tmux",
            "moyiz/blink-emoji.nvim",
            "disrupted/blink-cmp-conventional-commits",
            "rafamadriz/friendly-snippets",
            "giuxtaposition/blink-cmp-copilot",
            {
                "saghen/blink.compat",
                optional = true, -- make optional so it's only enabled if any extras need it

                opts = {},
            },
        },
        event = { "InsertEnter", "CmdlineEnter" },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            appearance = {
                -- sets the fallback highlight groups to nvim-cmp's highlight groups
                -- useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release, assuming themes add support
                use_nvim_cmp_as_default = true,
                -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font' l
                --
                -- adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },
            completion = {
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    auto_show = function()
                        return vim.bo.filetype ~= "markdown"
                    end,
                    draw = {
                        treesitter = { "lsp" },
                        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                ghost_text = {
                    enabled = vim.g.ai_cmp,
                },
            },
            sources = {
                -- adding any nvim-cmp sources here will enable them
                -- with blink.compat
                compat = {},
                default = { "copilot", "lazydev", "conventional_commits", "lsp", "path", "snippets", "buffer", "emoji" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 15, -- Tune by preference
                        opts = {
                            trigger_chars = { ":" },
                        },
                        should_show_items = function()
                            return vim.tbl_contains(
                                -- Enable emoji completion only for git commits and markdown.
                                -- By default, enabled for all file-types.
                                { "gitcommit", "markdown" },
                                vim.o.filetype
                            )
                        end,
                    },
                    conventional_commits = {
                        name = "Conventional Commits",
                        module = "blink-cmp-conventional-commits",
                        enabled = function()
                            return vim.bo.filetype == "gitcommit"
                        end,
                    },
                    buffer = {
                        enabled = function()
                            return vim.bo.filetype ~= "markdown"
                        end,
                    },
                },
            },
            keymap = {
                -- Add personal keymaps to this portion of blink config
                preset = "none",
                ["<C-n>"] = { "show", "select_next" },
                ["<C-p>"] = { "select_prev" },
                ["<C-b>"] = { "scroll_documentation_up" },
                ["<C-f>"] = { "scroll_documentation_down" },
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" }, -- doesn't seem like this works
                ["<C-e>"] = { "cancel" },
                ["<C-CR>"] = { "cancel", "fallback" },
                ["<Tab>"] = {
                    function(cmp)
                        Utils.create_undo()
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    Utils.cmp.map({ "snippet_forward", "ai_accept" }),
                    "fallback",
                },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                -- Arrow keys for cycling through suggestions when menu is open
                ["<Down>"] = {
                    function(cmp)
                        if cmp.is_visible() then
                            return cmp.select_next()
                        end
                    end,
                    "fallback",
                },
                ["<Up>"] = {
                    function(cmp)
                        if cmp.is_visible() then
                            return cmp.select_prev()
                        end
                    end,
                    "fallback",
                },
                -- Homerow alt-mappings
                ["<M-h>"] = { "show_documentation", "hide_documentation" },
                ["<M-j>"] = { "show", "select_next" },
                ["<M-k>"] = { "select_prev" },
                ["<M-l>"] = { "select_and_accept", Utils.cmp.map({ "ai_accept" }) },
                ["<M-;>"] = { "cancel" },
            },
            cmdline = {
                keymap = {
                    preset = "inherit",
                    ["<Tab>"] = { "fallback" },
                },
                completion = { menu = { auto_show = false } }, -- Toggle this to automatically show completion menu on cmdline
            },
        },
        ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
        config = function(_, opts)
            -- setup compat sources
            local enabled = opts.sources.default
            for _, source in ipairs(opts.sources.compat or {}) do
                opts.sources.providers[source] = vim.tbl_deep_extend(
                    "force",
                    { name = source, module = "blink.compat.source" },
                    opts.sources.providers[source] or {}
                )
                if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
                    table.insert(enabled, source)
                end
            end
            -- Unset custom prop to pass blink.cmp validation
            opts.sources.compat = nil

            require("blink.cmp").setup(opts)
        end,
    },
    {
        "junegunn/vim-easy-align",
        ft = "markdown",
        keys = {
            { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy Align" },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                callback = function()
                    vim.keymap.set(
                        "v",
                        "<tab>",
                        ":EasyAlign*<Bar><CR>",
                        { buffer = true, desc = "Align markdown table" }
                    )
                    vim.keymap.set(
                        "n",
                        "<Bar>",
                        "vip :EasyAlign*<Bar><CR>",
                        { buffer = true, desc = "Select and align markdown table" }
                    )
                end,
            })
        end,
    },
}
