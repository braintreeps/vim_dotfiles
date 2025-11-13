-- Formatting: Set up formatters using conform.nvim.

return {
    {
        "stevearc/conform.nvim",
        -- we need to add a tool to manage these formatters/tools.
        -- @see `mason-tools-installer`
        -- https://github.com/stevearc/conform.nvim/issues/104
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>F",
                function()
                    require("conform").format({ async = true, lsp_fallback = false })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            notify_on_error = true,
            log_level = vim.log.levels.INFO,
            formatters_by_ft = {
                sql = { "sqlfluff" },
                lua = { "stylua" },
            },
            formatters = {
                sqlfluff = {
                    args = { "fix", "--force", "-" },
                },
            },
        },
    },
}
