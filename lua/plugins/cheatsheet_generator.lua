return {
    {
        "cosmicbuffalo/cheatsheet_generator.nvim",
        opts = {
            plugin_dirs = { "lua/plugins" },
            config_keymap_files = { "lua/config/keymaps.lua" },
            output = {
                title = "Braintree Keymap Cheatsheet",
                runtime_note = {
                    keymap_search = "<leader>sk",
                },
            },
            manual_keymaps = {
                ["telescope.nvim"] = {
                    -- Built in telescope keymaps
                    { keymap = "<C-n>", mode = "i", desc = "Next item", source = "Built in telescope default" },
                    { keymap = "<Down>", mode = "i", desc = "Next item", source = "Built in telescope default" },
                    { keymap = "<C-p>", mode = "i", desc = "Previous item", source = "Built in telescope default" },
                    { keymap = "<Up>", mode = "i", desc = "Previous item", source = "Built in telescope default" },
                    { keymap = "j", mode = "n", desc = "Next item", source = "Built in telescope default" },
                    { keymap = "k", mode = "n", desc = "Previous item", source = "Built in telescope default" },
                    { keymap = "H", mode = "n", desc = "Select High", source = "Built in telescope default" },
                    { keymap = "M", mode = "n", desc = "Select Middle", source = "Built in telescope default" },
                    { keymap = "L", mode = "n", desc = "Select Low", source = "Built in telescope default" },
                    { keymap = "gg", mode = "n", desc = "Select the first item", source = "Built in telescope default" },
                    { keymap = "G", mode = "n", desc = "Select the last item", source = "Built in telescope default" },
                    { keymap = "<CR>", mode = "i", desc = "Confirm selection", source = "Built in telescope default" },
                    { keymap = "<CR>", mode = "n", desc = "Confirm selection", source = "Built in telescope default" },
                    { keymap = "<C-x>", mode = "i", desc = "Go to file selection as a split", source = "Built in telescope default" },
                    { keymap = "<C-x>", mode = "n", desc = "Go to file selection as a split", source = "Built in telescope default" },
                    { keymap = "<C-v>", mode = "i", desc = "Go to file selection as a vsplit", source = "Built in telescope default" },
                    { keymap = "<C-v>", mode = "n", desc = "Go to file selection as a vsplit", source = "Built in telescope default" },
                    { keymap = "<C-u>", mode = "i", desc = "Scroll up in preview window", source = "Built in telescope default" },
                    { keymap = "<C-u>", mode = "n", desc = "Scroll up in preview window", source = "Built in telescope default" },
                    { keymap = "<C-d>", mode = "i", desc = "Scroll down in preview window", source = "Built in telescope default" },
                    { keymap = "<C-d>", mode = "n", desc = "Scroll down in preview window", source = "Built in telescope default" },
                    { keymap = "<C-f>", mode = "i", desc = "Scroll left in preview window", source = "Built in telescope default" },
                    { keymap = "<C-f>", mode = "n", desc = "Scroll left in preview window", source = "Built in telescope default" },
                    { keymap = "<C-k>", mode = "i", desc = "Scroll right in preview window", source = "Built in telescope default" },
                    { keymap = "<C-k>", mode = "n", desc = "Scroll right in preview window", source = "Built in telescope default" },
                    { keymap = "<M-f>", mode = "i", desc = "Scroll left in results window", source = "Built in telescope default" },
                    { keymap = "<M-f>", mode = "n", desc = "Scroll left in results window", source = "Built in telescope default" },
                    { keymap = "<M-k>", mode = "i", desc = "Scroll right in results window", source = "Built in telescope default" },
                    { keymap = "<M-k>", mode = "n", desc = "Scroll right in results window", source = "Built in telescope default" },
                    { keymap = "<C-/>", mode = "i", desc = "Show mappings for picker actions", source = "Built in telescope default" },
                    { keymap = "?", mode = "n", desc = "Show mappings for picker actions", source = "Built in telescope default" },
                    { keymap = "<C-c>", mode = "i", desc = "Close telescope", source = "Built in telescope default" },
                    { keymap = "<Esc>", mode = "n", desc = "Close telescope", source = "Built in telescope default" },
                    { keymap = "<Tab>", mode = "i", desc = "Toggle selection and move to next selection", source = "Built in telescope default" },
                    { keymap = "<Tab>", mode = "n", desc = "Toggle selection and move to next selection", source = "Built in telescope default" },
                    { keymap = "<S-Tab>", mode = "i", desc = "Toggle selection and move to prev selection", source = "Built in telescope default" },
                    { keymap = "<S-Tab>", mode = "n", desc = "Toggle selection and move to prev selection", source = "Built in telescope default" },
                    { keymap = "<C-q>", mode = "i", desc = "Send all items not filtered to quickfixlist", source = "Built in telescope default" },
                    { keymap = "<C-q>", mode = "n", desc = "Send all items not filtered to quickfixlist", source = "Built in telescope default" },
                    { keymap = "<M-q>", mode = "i", desc = "Send all selected items to qflist", source = "Built in telescope default" },
                    { keymap = "<M-q>", mode = "n", desc = "Send all selected items to qflist", source = "Built in telescope default" },
                    { keymap = "<C-r><C-w>", mode = "i", desc = "Insert cword in original window into prompt", source = "Built in telescope default" },
                    { keymap = "<C-r><C-a>", mode = "i", desc = "Insert cWORD in original window into prompt", source = "Built in telescope default" },

                    -- Telescope keymap customizations
                    { keymap = "d", mode = "n", desc = "Delete buffer (in buffer explorer)", source = "lua/plugins/ui.lua" },
                    { keymap = "<C-t>", mode = "i", desc = "Scope to directory (with picker open)", source = "lua/plugins/ui.lua" },
                    { keymap = "<C-t>", mode = "n", desc = "Scope to directory (with picker open)", source = "lua/plugins/ui.lua" },
                }
            }
        },
        cmd = { "CheatsheetGenerate", "CheatsheetInstallHook" },
    },
}
