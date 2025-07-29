local Utils = require("config.utils")
local LazyFileEvents = Utils.lazy.LazyFileEvents

local open_lazygit_with_tracked_window = function()
    Utils.set_tracked_window()
    Snacks.lazygit()
end

local remote_q = 'nvim --server "$NVIM" --remote-send "q"'
local remote_open_with_tracked_window = 'nvim --server "$NVIM" --remote-send "<C-\\><C-N>:lua require(\\"config.utils\\").open_in_tracked_window(\\"{{filename}}\\")<CR>"'
local remote_goto_line = 'nvim --server "$NVIM" --remote-send ":{{line}}<CR>"'
local remote_q_open = remote_q .. ' && ' .. remote_open_with_tracked_window
local lazygit_edit_command = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (' .. remote_q_open .. ')'
local lazygit_edit_at_line_command = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (' .. remote_q_open .. ' && ' .. remote_goto_line .. ')'

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = LazyFileEvents,
        cmd = { "IBLEnable", "IBLDisable", "IBLToggle", "IBLEnableScope", "IBLDisableScope", "IBLToggleScope" },
        keys = {
            {
                "<leader>uI",
                function()
                    require("ibl").setup_buffer(0, { enabled = not require("ibl.config").get_config(0).enabled })
                end,
                desc = "Toggle Indention Guides",
            },
        },
        opts = function()
            return {
                indent = {
                    char = "│",
                    tab_char = "│",
                },
                scope = { show_start = false, show_end = false },
                exclude = {
                    filetypes = {
                        "Trouble",
                        "alpha",
                        "dashboard",
                        "help",
                        "lazy",
                        "mason",
                        "neo-tree",
                        "notify",
                        "snacks_dashboard",
                        "snacks_notif",
                        "snacks_terminal",
                        "snacks_win",
                        "toggleterm",
                        "trouble",
                    },
                },
            }
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            dashboard = {
                enabled = false,
                preset = {
                    header = [[
	██████╗ ██████╗  █████╗ ██╗███╗   ██╗████████╗██████╗ ███████╗███████╗
	██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║╚══██╔══╝██╔══██╗██╔════╝██╔════╝
	██████╔╝██████╔╝███████║██║██╔██╗ ██║   ██║   ██████╔╝█████╗  █████╗
	██╔══██╗██╔══██╗██╔══██║██║██║╚██╗██║   ██║   ██╔══██╗██╔══╝  ██╔══╝
	██████╔╝██║  ██║██║  ██║██║██║ ╚████║   ██║   ██║  ██║███████╗███████╗
	╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝

					]],
                }
            },
            lazygit = {
                config = {
                    os = {
                        edit = lazygit_edit_command,
                        editAtLine = lazygit_edit_at_line_command,
                        editAtLineAndWait = 'nvim +{{line}} {{filename}}',
                        openDirInEditor =
                        '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
                    }
                }
            },
            zen = {},
        },
        keys = {
            { "<leader>gg", function() open_lazygit_with_tracked_window() end, desc = "Lazygit" },
            { "<leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame" },
            { "<leader>b.", function() Snacks.scratch() end,        desc = "New Scratch [b]uffer" },
            { "<leader>bS", function() Snacks.scratch.select() end, desc = "Scratch [b]uffer [S]elect" },
            { "<leader>uZ", function() Snacks.zen() end,            desc = "[Z]en mode" },
        },
    },
    {
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim",
        },
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
            require("windows").setup()
        end,
        keys = {
            { "<leader>wm", "<Cmd>WindowsMaximize<CR>",             desc = "Maximize window (toggle)" },
            { "<leader>wh", "<Cmd>WindowsMaximizeHorizontally<CR>", desc = "Maximize window horizontally" },
            { "<leader>wv", "<Cmd>WindowsMaximizeVertically<CR>",   desc = "Maximize window vertically" },
            { "<leader>we", "<Cmd>WindowsEqualize<CR>",             desc = "Equalize windows" },
            { "<leader>wa", "<Cmd>WindowsToggleAutowidth<CR>",      desc = "Toggle window autowidth" },
            { "<C-w>a",     "<Cmd>WindowsToggleAutowidth<CR>",      desc = "Toggle window autowidth" },
            { "<leader>ww", "<C-W>p",                               desc = "Other Window",                remap = true },
            { "<leader>wd", "<C-W>c",                               desc = "Delete Window",               remap = true },
        }
    },
    {
        "cosmicbuffalo/updater.nvim",
        event = "VimEnter", -- Needs to be loaded early so that it can check for updates on startup
        opts = {
            keymap = {
                open = "<leader>e",
            },
            check_updates_on_startup = { enabled = true },
            periodic_check = {
                enabled = true,
                frequency_minutes = 120,
            }
        },
        cmd = { "UpdaterOpen", "UpdaterCheck", "UpdaterStartChecking", "UpdaterStopChecking" },
        keys = {
            { "<leader>e", "<Cmd>UpdaterOpen<CR>", desc = "Open Updater" },
        }
    }
}
