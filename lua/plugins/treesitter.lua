-- TreeSitter: advanced syntax highlighting and plugins that use Treesitter parsers

-- TODO expose this as a configurable value
local treesitter_highlight_max_file_size = 150 -- Kilobytes

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdateSync",
        event = { "BufNewFile", "BufReadPost" },
        dependencies = {
            "RRethy/nvim-treesitter-endwise",
            "RRethy/vim-illuminate",
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
            local config = require("nvim-treesitter.configs")
            config.setup(opts)
        end,
    },
}
