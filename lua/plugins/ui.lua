-- UI: Enhance the user interface with features such as status line, buffer line, indentation guides, dashboard, and icons.
local Utils = require('lazy_utils')
local SwitchColorschemeKeyMap = Utils.SwitchColorschemeKeyMap

-- cache results of rev-parse
local is_inside_work_tree = {}

function vim.find_files_from_project_git_root()
    local opts = Utils.opts('telescope.nvim').pickers.find_files
    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
    end

    if is_inside_work_tree[cwd] then
        require("telescope.builtin").git_files(opts)
    else
        require("telescope.builtin").find_files(opts)
    end
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "AndreM222/copilot-lualine",
        },
        opts = function()
            local conf = require("lualine").get_config()

            local new_conf = vim.tbl_deep_extend("force", conf, {
                sections = {
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                        },
                    },
                    lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
                },
            })

            return new_conf
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "echasnovski/mini.bufremove",
        },
        keys = {
            { "<Leader><Leader>", "<cmd>Telescope find_files<CR>",      desc = "Find files" },
            { "<Leader>ff",       vim.find_files_from_project_git_root, desc = "Find (git) files" },
            { "<C-p>",            vim.find_files_from_project_git_root, desc = "Find (git) files" },
            { "<Leader>fg",       "<cmd>Telescope live_grep<CR>",       desc = "Find (grep)" },
            {
                "<Leader>be",
                function()
                    require("telescope.builtin").buffers({
                        attach_mappings = function(prompt_bufnr, map)
                            local action_state = require("telescope.actions.state")
                            local bd = require("mini.bufremove").delete
                            local delete_buffer = function()
                                local current_picker = action_state.get_current_picker(prompt_bufnr)
                                current_picker:delete_selection(function(selection)
                                    local bufnr = selection.bufnr
                                    local force = vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal"
                                    if force then
                                        return pcall(vim.api.nvim_buf_delete, bufnr, { force = force })
                                    elseif vim.fn.getbufvar(bufnr, "&modified") == 1 then
                                        local choice =
                                            vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)),
                                                "&Yes\n&No\n&Cancel")
                                        if choice == 1 then -- Yes
                                            vim.api.nvim_buf_call(bufnr, function()
                                                vim.cmd("write")
                                            end)
                                            return bd(bufnr)
                                        elseif choice == 2 then -- No
                                            return bd(bufnr, true)
                                        end
                                    else
                                        return bd(bufnr)
                                    end
                                end)
                            end
                            map("n", "d", delete_buffer)
                            return true
                        end,
                    })
                end,
                desc = "Buffer Explorer"
            },
            { "<Leader>fr", "<cmd>Telescope oldfiles<CR>",    desc = "Find Recent" },
            { "<Leader>gw", "<cmd>Telescope grep_string<CR>", desc = "Grep word in cursor" },
            { "<Leader>fh", "<cmd>Telescope man_pages<CR>",   desc = "Find help pages" },
            { "<Leader>fm", "<cmd>Telescope keymaps<CR>",     desc = "Find keymappings" },
            SwitchColorschemeKeyMap,
        },
        opts = {
            defaults = {
                file_ignore_patterns = { "node_modules/", ".git/refs/", ".git/logs", ".git/objects", "sorbet/rbi/annotations/", "sorbet/rbi/dsl/", "sorbet/rbi/gems/" },
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = 'top',
                    horizontal = {
                        width = { padding = 0 },
                        height = { padding = 0 },
                        preview_width = 0.5
                    },
                },
            },
            pickers = {
                live_grep = {
                    additional_args = function(_)
                        return { "--hidden" }
                    end,
                },
                find_files = {
                    hidden = true,
                },
                git_files = {
                    show_untracked = true,
                },
            },
        },
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function(_, _opts)
            require("telescope").load_extension("ui-select")
        end,
    },
}
