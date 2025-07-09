local Utils = require("config.utils")
local LazyFileEvents = Utils.lazy.LazyFileEvents

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
                        edit =
                        '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
                        editAtLine =
                        '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
                        editAtLineAndWait = 'nvim +{{line}} {{filename}}',
                        openDirInEditor =
                        '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
                    }
                }
            },
            zen = {},
        },
        keys = {
            { "<leader>gg", function() Snacks.lazygit() end,        desc = "Lazygit" },
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
