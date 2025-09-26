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
                ["vim-unimpaired"] = {
                    -- Navigation
                    { keymap = "[a", mode = "n", desc = "Previous file in argument list", source = "vim-unimpaired built in default" },
                    { keymap = "]a", mode = "n", desc = "Next file in argument list", source = "vim-unimpaired built in default" },
                    { keymap = "[A", mode = "n", desc = "First file in argument list", source = "vim-unimpaired built in default" },
                    { keymap = "]A", mode = "n", desc = "Last file in argument list", source = "vim-unimpaired built in default" },

                    { keymap = "[b", mode = "n", desc = "Previous buffer", source = "vim-unimpaired built in default" },
                    { keymap = "]b", mode = "n", desc = "Next buffer", source = "vim-unimpaired built in default" },
                    { keymap = "[B", mode = "n", desc = "First buffer", source = "vim-unimpaired built in default" },
                    { keymap = "]B", mode = "n", desc = "Last buffer", source = "vim-unimpaired built in default" },

                    { keymap = "[l", mode = "n", desc = "Previous location list item", source = "vim-unimpaired built in default" },
                    { keymap = "]l", mode = "n", desc = "Next location list item", source = "vim-unimpaired built in default" },
                    { keymap = "[L", mode = "n", desc = "First location list item", source = "vim-unimpaired built in default" },
                    { keymap = "]L", mode = "n", desc = "Last location list item", source = "vim-unimpaired built in default" },
                    { keymap = "[<C-L>", mode = "n", desc = "Previous location file", source = "vim-unimpaired built in default" },
                    { keymap = "]<C-L>", mode = "n", desc = "Next location file", source = "vim-unimpaired built in default" },

                    { keymap = "[q", mode = "n", desc = "Previous quickfix item", source = "vim-unimpaired built in default" },
                    { keymap = "]q", mode = "n", desc = "Next quickfix item", source = "vim-unimpaired built in default" },
                    { keymap = "[Q", mode = "n", desc = "First quickfix item", source = "vim-unimpaired built in default" },
                    { keymap = "]Q", mode = "n", desc = "Last quickfix item", source = "vim-unimpaired built in default" },
                    { keymap = "[<C-Q>", mode = "n", desc = "Previous quickfix file", source = "vim-unimpaired built in default" },
                    { keymap = "]<C-Q>", mode = "n", desc = "Next quickfix file", source = "vim-unimpaired built in default" },

                    { keymap = "[t", mode = "n", desc = "Previous tag", source = "vim-unimpaired built in default" },
                    { keymap = "]t", mode = "n", desc = "Next tag", source = "vim-unimpaired built in default" },
                    { keymap = "[T", mode = "n", desc = "First tag", source = "vim-unimpaired built in default" },
                    { keymap = "]T", mode = "n", desc = "Last tag", source = "vim-unimpaired built in default" },
                    { keymap = "[<C-T>", mode = "n", desc = "Previous preview tag", source = "vim-unimpaired built in default" },
                    { keymap = "]<C-T>", mode = "n", desc = "Next preview tag", source = "vim-unimpaired built in default" },

                    { keymap = "[f", mode = "n", desc = "Previous file in directory", source = "vim-unimpaired built in default" },
                    { keymap = "]f", mode = "n", desc = "Next file in directory", source = "vim-unimpaired built in default" },
                    { keymap = "[n", mode = "n", desc = "Previous SCM conflict marker", source = "vim-unimpaired built in default" },
                    { keymap = "]n", mode = "n", desc = "Next SCM conflict marker", source = "vim-unimpaired built in default" },

                    -- Line Operations
                    { keymap = "[<Space>", mode = "n", desc = "Add blank lines above", source = "vim-unimpaired built in default" },
                    { keymap = "]<Space>", mode = "n", desc = "Add blank lines below", source = "vim-unimpaired built in default" },

                    { keymap = "[e", mode = "n", desc = "Exchange line up", source = "vim-unimpaired built in default" },
                    { keymap = "]e", mode = "n", desc = "Exchange line down", source = "vim-unimpaired built in default" },
                    { keymap = "[e", mode = "v", desc = "Exchange selection up", source = "vim-unimpaired built in default" },
                    { keymap = "]e", mode = "v", desc = "Exchange selection down", source = "vim-unimpaired built in default" },

                    -- Option Toggling
                    { keymap = "[ob", mode = "n", desc = "Set background=dark", source = "vim-unimpaired built in default" },
                    { keymap = "]ob", mode = "n", desc = "Set background=light", source = "vim-unimpaired built in default" },
                    { keymap = "yob", mode = "n", desc = "Toggle background", source = "vim-unimpaired built in default" },

                    { keymap = "[oc", mode = "n", desc = "Enable cursorline", source = "vim-unimpaired built in default" },
                    { keymap = "]oc", mode = "n", desc = "Disable cursorline", source = "vim-unimpaired built in default" },
                    { keymap = "yoc", mode = "n", desc = "Toggle cursorline", source = "vim-unimpaired built in default" },

                    { keymap = "[od", mode = "n", desc = "Enable diff", source = "vim-unimpaired built in default" },
                    { keymap = "]od", mode = "n", desc = "Disable diff", source = "vim-unimpaired built in default" },
                    { keymap = "yod", mode = "n", desc = "Toggle diff", source = "vim-unimpaired built in default" },

                    { keymap = "[oh", mode = "n", desc = "Enable hlsearch", source = "vim-unimpaired built in default" },
                    { keymap = "]oh", mode = "n", desc = "Disable hlsearch", source = "vim-unimpaired built in default" },
                    { keymap = "yoh", mode = "n", desc = "Toggle hlsearch", source = "vim-unimpaired built in default" },

                    { keymap = "[oi", mode = "n", desc = "Enable ignorecase", source = "vim-unimpaired built in default" },
                    { keymap = "]oi", mode = "n", desc = "Disable ignorecase", source = "vim-unimpaired built in default" },
                    { keymap = "yoi", mode = "n", desc = "Toggle ignorecase", source = "vim-unimpaired built in default" },

                    { keymap = "[ol", mode = "n", desc = "Enable list", source = "vim-unimpaired built in default" },
                    { keymap = "]ol", mode = "n", desc = "Disable list", source = "vim-unimpaired built in default" },
                    { keymap = "yol", mode = "n", desc = "Toggle list", source = "vim-unimpaired built in default" },

                    { keymap = "[on", mode = "n", desc = "Enable number", source = "vim-unimpaired built in default" },
                    { keymap = "]on", mode = "n", desc = "Disable number", source = "vim-unimpaired built in default" },
                    { keymap = "yon", mode = "n", desc = "Toggle number", source = "vim-unimpaired built in default" },

                    { keymap = "[or", mode = "n", desc = "Enable relativenumber", source = "vim-unimpaired built in default" },
                    { keymap = "]or", mode = "n", desc = "Disable relativenumber", source = "vim-unimpaired built in default" },
                    { keymap = "yor", mode = "n", desc = "Toggle relativenumber", source = "vim-unimpaired built in default" },

                    { keymap = "[os", mode = "n", desc = "Enable spell", source = "vim-unimpaired built in default" },
                    { keymap = "]os", mode = "n", desc = "Disable spell", source = "vim-unimpaired built in default" },
                    { keymap = "yos", mode = "n", desc = "Toggle spell", source = "vim-unimpaired built in default" },

                    { keymap = "[ot", mode = "n", desc = "Enable colorcolumn", source = "vim-unimpaired built in default" },
                    { keymap = "]ot", mode = "n", desc = "Disable colorcolumn", source = "vim-unimpaired built in default" },
                    { keymap = "yot", mode = "n", desc = "Toggle colorcolumn", source = "vim-unimpaired built in default" },

                    { keymap = "[ou", mode = "n", desc = "Enable cursorcolumn", source = "vim-unimpaired built in default" },
                    { keymap = "]ou", mode = "n", desc = "Disable cursorcolumn", source = "vim-unimpaired built in default" },
                    { keymap = "you", mode = "n", desc = "Toggle cursorcolumn", source = "vim-unimpaired built in default" },

                    { keymap = "[ov", mode = "n", desc = "Enable virtualedit", source = "vim-unimpaired built in default" },
                    { keymap = "]ov", mode = "n", desc = "Disable virtualedit", source = "vim-unimpaired built in default" },
                    { keymap = "yov", mode = "n", desc = "Toggle virtualedit", source = "vim-unimpaired built in default" },

                    { keymap = "[ow", mode = "n", desc = "Enable wrap", source = "vim-unimpaired built in default" },
                    { keymap = "]ow", mode = "n", desc = "Disable wrap", source = "vim-unimpaired built in default" },
                    { keymap = "yow", mode = "n", desc = "Toggle wrap", source = "vim-unimpaired built in default" },

                    { keymap = "[ox", mode = "n", desc = "Enable crosshairs", source = "vim-unimpaired built in default" },
                    { keymap = "]ox", mode = "n", desc = "Disable crosshairs", source = "vim-unimpaired built in default" },
                    { keymap = "yox", mode = "n", desc = "Toggle crosshairs", source = "vim-unimpaired built in default" },

                    -- Pasting
                    { keymap = ">p", mode = "n", desc = "Paste after with increased indent", source = "vim-unimpaired built in default" },
                    { keymap = ">P", mode = "n", desc = "Paste before with increased indent", source = "vim-unimpaired built in default" },
                    { keymap = "<p", mode = "n", desc = "Paste after with decreased indent", source = "vim-unimpaired built in default" },
                    { keymap = "<P", mode = "n", desc = "Paste before with decreased indent", source = "vim-unimpaired built in default" },
                    { keymap = "=p", mode = "n", desc = "Paste after with reindent", source = "vim-unimpaired built in default" },
                    { keymap = "=P", mode = "n", desc = "Paste before with reindent", source = "vim-unimpaired built in default" },
                    { keymap = "[op", mode = "n", desc = "Paste line above with paste mode", source = "vim-unimpaired built in default" },
                    { keymap = "]op", mode = "n", desc = "Paste line below with paste mode", source = "vim-unimpaired built in default" },
                    { keymap = "yop", mode = "n", desc = "Paste at cursor with paste mode", source = "vim-unimpaired built in default" },

                    -- Encoding/Decoding
                    { keymap = "[x", mode = "n", desc = "XML encode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "]x", mode = "n", desc = "XML decode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "[xx", mode = "n", desc = "XML encode line", source = "vim-unimpaired built in default" },
                    { keymap = "]xx", mode = "n", desc = "XML decode line", source = "vim-unimpaired built in default" },
                    { keymap = "[x", mode = "v", desc = "XML encode selection", source = "vim-unimpaired built in default" },
                    { keymap = "]x", mode = "v", desc = "XML decode selection", source = "vim-unimpaired built in default" },
                    { keymap = "[u", mode = "n", desc = "URL encode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "]u", mode = "n", desc = "URL decode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "[uu", mode = "n", desc = "URL encode line", source = "vim-unimpaired built in default" },
                    { keymap = "]uu", mode = "n", desc = "URL decode line", source = "vim-unimpaired built in default" },
                    { keymap = "[u", mode = "v", desc = "URL encode selection", source = "vim-unimpaired built in default" },
                    { keymap = "]u", mode = "v", desc = "URL decode selection", source = "vim-unimpaired built in default" },
                    { keymap = "[y", mode = "n", desc = "C string encode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "]y", mode = "n", desc = "C string decode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "[yy", mode = "n", desc = "C string encode line", source = "vim-unimpaired built in default" },
                    { keymap = "]yy", mode = "n", desc = "C string decode line", source = "vim-unimpaired built in default" },
                    { keymap = "[y", mode = "v", desc = "C string encode selection", source = "vim-unimpaired built in default" },
                    { keymap = "]y", mode = "v", desc = "C string decode selection", source = "vim-unimpaired built in default" },
                    { keymap = "[C", mode = "n", desc = "C string encode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "]C", mode = "n", desc = "C string decode (motion)", source = "vim-unimpaired built in default" },
                    { keymap = "[CC", mode = "n", desc = "C string encode line", source = "vim-unimpaired built in default" },
                    { keymap = "]CC", mode = "n", desc = "C string decode line", source = "vim-unimpaired built in default" },
                    { keymap = "[C", mode = "v", desc = "C string encode selection", source = "vim-unimpaired built in default" },
                    { keymap = "]C", mode = "v", desc = "C string decode selection", source = "vim-unimpaired built in default" },

                },
                ["telescope.nvim"] = {
                    -- Telescope keymap customizations
                    { keymap = "d", mode = "n", desc = "Delete buffer (in buffer explorer)", source = "lua/plugins/ui.lua" },
                    { keymap = "<C-e>", mode = "i", desc = "Scope to directory (with picker open)", source = "lua/plugins/ui.lua" },
                    { keymap = "<C-e>", mode = "n", desc = "Scope to directory (with picker open)", source = "lua/plugins/ui.lua" },

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
                    { keymap = "<C-t>", mode = "i", desc = "Go to file selection in a new tab", source = "Built in telescope default" },
                    { keymap = "<C-t>", mode = "n", desc = "Go to file selection in a new tab", source = "Built in telescope default" },
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

                }
            }
        },
        cmd = { "CheatsheetGenerate", "CheatsheetInstallHook" },
    },
}
