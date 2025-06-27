-- TreeSitter: advanced syntax highlighting and plugins that use Treesitter parsers

-- TODO expose this as a configurable value
local treesitter_highlight_max_file_size = 150 -- Kilobytes

return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "VeryLazy" },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and load custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treesitter** module to be loaded in time.
            -- Luckily, the only things that those plugins need are custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        dependencies = {
            "RRethy/nvim-treesitter-endwise",
            "RRethy/vim-illuminate",
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                config = function()
                    -- When in diff mode, we want to use the default
                    -- vim text objects c & C instead of the treesitter ones.
                    local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
                    local configs = require("nvim-treesitter.configs")
                    for name, fn in pairs(move) do
                        if name:find("goto") == 1 then
                            move[name] = function(q, ...)
                                if vim.wo.diff then
                                    local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                                    for key, query in pairs(config or {}) do
                                        if q == query and key:find("[%]%[][cC]") then
                                            vim.cmd("normal! " .. key)
                                            return
                                        end
                                    end
                                end
                                return fn(q, ...)
                            end
                        end
                    end
                end,
            },
        },
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "ruby" },
                disable = function(_lang, buffer)
                    local max_filesize = treesitter_highlight_max_file_size * 1024 -- convert actual kilobytes
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buffer))

                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            incremental_selection = {
                enable = true,
            },
            indent = {
                enable = true,
                disable = { "ruby" }, -- ruby indenting doesn't seem to be working yet
            },
            endwise = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    keymaps = {
                        ["ac"] = { query = "@class.outer", desc = "Select around class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inside class" },
                        ["af"] = { query = "@function.outer", desc = "Select around function" },
                        ["if"] = { query = "@function.inner", desc = "Select inside function" },
                        ["al"] = { query = "@loop.outer", desc = "Select around loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inside loop" },
                        ["ab"] = { query = "@block.outer", desc = "Select around block" },
                        ["ib"] = { query = "@block.inner", desc = "Select inside block" },
                    },
                    selection_modes = {
                        ["@class.outer"] = "V",
                    },
                },
                move = {
                    enable = true,
                    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                },
            },
            ensure_installed = {
                "bash",
                "cmake",
                "diff",
                "dockerfile",
                "embedded_template",
                "git_config",
                "git_rebase",
                "gitcommit",
                "gitignore",
                "go",
                "groovy",
                "hcl",
                "html",
                "http",
                "java",
                "javascript",
                "jq",
                "json",
                "kotlin",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "properties",
                "proto",
                "puppet",
                "python",
                "ruby",
                "rust",
                "sql",
                "ssh_config",
                "terraform",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
