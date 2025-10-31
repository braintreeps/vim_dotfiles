-- Editor: Provides functionality like a file explorer, search and replace, fuzzy finding, git integration.

local LazyFileEvents = require("config.utils.lazy").LazyFileEvents

return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            spec = {
                { "<leader>A", group = "Alternate" },
                { "<leader>a", group = "AI", mode = { "n", "v" } },
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code / LSP", mode = { "n", "v" } },
                { "<leader>cw", group = "Workspace" },
                { "<leader>d", group = "Diagnostics" },
                { "<leader>f", group = "Find" },
                { "<leader>n", group = "Neotree" },
                { "<leader>r", group = "Run tests" },
                { "<leader>u", group = "UI" },
                { "<leader>v", group = "Vimux", mode = { "n", "v" } },
                { "<leader>s", group = "Search", mode = { "n", "v" } },
                { "<leader>q", group = "Session" },
                { "<leader>g", group = "Git", mode = { "n", "v" } },
                { "<leader>w", group = "Windows" },
                { "<leader>x", group = "Quickfix" },
                { "<leader><tab>", group = "Tabs" },
                { "zj", desc = "Move to next fold" },
                { "zk", desc = "Move to previous fold" },
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim", -- Show diffs and more!
        event = LazyFileEvents,
        opts = {
            current_line_blame = true,
        },
        keys = {
            { "<Leader>bl", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Line Blame" },
            { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Line Blame" },
            { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Next git hunk" },
            { "]h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev git hunk" },
            { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select git hunk", mode = { "o", "x" } },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "[g]it [r]eset hunk" },
            { "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "[g]it [R]eset buffer" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "[g]it [s]tage hunk" },
            { "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", desc = "[g]it [S]tage buffer" },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "[g]it [u]nstage hunk" },
            { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "[g]it [d]iff this" },
            { "<leader>gD", '<cmd>Gitsigns diffthis "~"<CR>', desc = "[g]it [D]iff this ~" },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            {
                "s1n7ax/nvim-window-picker",
                version = "2.*",
                config = function()
                    require("window-picker").setup({
                        filter_rules = {
                            include_current_win = false,
                            autoselect_one = true,
                            -- filter using buffer options
                            bo = {
                                -- if the file type is one of following, the window will be ignored
                                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                                -- if the buffer type is one of following, the window will be ignored
                                buftype = { "terminal", "quickfix" },
                            },
                        },
                    })
                end,
            },
        },
        keys = {
            { "<Leader>nt", "<cmd>Neotree toggle<CR>", desc = "Neotree toggle" },
            { "<Leader>nf", "<cmd>Neotree reveal<CR>", desc = "Neotree focus file" },
        },
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                use_libuv_file_watcher = true,
                filtered_items = {
                    hide_hidden = false,
                    hide_dotfiles = false,
                },
            },
            window = {
                mappings = {
                    ["<space>"] = "none",
                    ["Y"] = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                    ["S"] = "split_with_window_picker",
                    ["s"] = "vsplit_with_window_picker",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        },
    },
    {
        "stevearc/resession.nvim",
        opts = {},
        lazy = false,
        keys = {
            { "<Leader>qs", "<cmd>SessionSaveWithDefaults<CR>", desc = "Save Session" },
            { "<Leader>ql", "<cmd>SessionLoadWithDefaults<CR>", desc = "Load Session" },
            { "<Leader>qd", "<cmd>SessionDeleteWithDefaults<CR>", desc = "Delete Session" },
        },
        config = function(_, _opts)
            local resession = require("resession")
            -- explicitly disable periodic autosave to be intentional
            resession.setup({
                autosave = {
                    enabled = false,
                },
            })

            local function get_session_name()
                -- let's name it after pwd + git branch
                local name = vim.fn.getcwd()
                local branch = vim.trim(vim.fn.system("git branch --show-current"))
                if vim.v.shell_error == 0 then
                    return name .. ":" .. branch
                else
                    return name
                end
            end

            -- Resession keymaps
            -- Default all session names to pwd + git branch
            vim.api.nvim_create_user_command("SessionSaveWithDefaults", function()
                resession.save(get_session_name())
            end, { desc = "Save session with name set to cwd + git branch" })

            vim.api.nvim_create_user_command("SessionLoadWithDefaults", function()
                resession.load(get_session_name())
            end, { desc = "Load session named for cwd + git branch" })

            vim.api.nvim_create_user_command("SessionDeleteWithDefaults", function()
                resession.delete(get_session_name())
            end, { desc = "Delete session named for cwd + git branch" })
        end,
    },
    {
        -- This recipe configures two plugins: `nvim-ufo` and `statuscol.nvim`
        -- both deal with functionality related to folds
        --  - `nvim-ufo` provides automatic fold creation, additional keymaps, and cosmetic enhancements to folds
        --  - `statuscol.nvim` provides a clickable status column with fold indicators similar to in other editors
        "cosmicbuffalo/lazy_ufo_recipe",
        enabled = false, -- Toggle this in your personal dotfiles to enable this recipe
        -- opts = {
        -- 	enable_next_line_virt_text = true,   -- optional, toggle this to enable "next line" virtual text in folds
        -- 	enable_align_suffix = true,          -- optional, toggle this to control the alignment of the fold suffix
        -- 	align_suffix_target_width = 80,      -- optional, set the target width for the fold suffix alignment
        -- }
    },
    {
        -- This recipe configures two plugins: `eyeliner.nvim` and `mini.jump`
        -- both affect the f/t/F/T motions
        -- - `eyeliner.nvim` adds visual indicators for the next f/t/F/T targets (cosmetic only, on by default)
        -- - `mini.jump` allows you to repeat/traverse f/t jumps with f/t keys (functinality change, off by default)
        "cosmicbuffalo/lazy_jumpliner_recipe",
        opts = {
            enable_eyeliner_by_default = true, -- Toggle this off to disable eyeliner by default
            enable_mini_jump = false, -- Toggle this on to enable mini jump
        },
    },
}
