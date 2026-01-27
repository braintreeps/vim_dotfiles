local Utils = require("config.utils")
local LazyFileEvents = Utils.lazy.LazyFileEvents

local open_lazygit_with_tracked_window = function()
    Utils.set_tracked_window()
    Snacks.lazygit()
end

local remote_q = 'nvim --server "$NVIM" --remote-send "q"'
local remote_open_with_tracked_window =
    'nvim --server "$NVIM" --remote-send "<C-\\><C-N>:lua require(\\"config.utils\\").open_in_tracked_window(\\"{{filename}}\\")<CR>"'
local remote_goto_line = 'nvim --server "$NVIM" --remote-send ":{{line}}<CR>"'
local remote_q_open = remote_q .. " && " .. remote_open_with_tracked_window
local lazygit_edit_command = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (' .. remote_q_open .. ")"
local lazygit_edit_at_line_command = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || ('
    .. remote_q_open
    .. " && "
    .. remote_goto_line
    .. ")"

return {
    {
        -- Pin lazy.nvim to stable releases and prevent accidental updates via `U`
        "folke/lazy.nvim",
        version = "*", -- only stable releases
        pin = true, -- never update unless explicitly unpinned
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = LazyFileEvents,
        cmd = { "IBLEnable", "IBLDisable", "IBLToggle", "IBLEnableScope", "IBLDisableScope", "IBLToggleScope" },
        keys = {
            {
                "<leader>uI",
                function()
                    local new_state = not require("ibl.config").get_config(0).enabled
                    require("ibl").update({ enabled = new_state })
                    if new_state then
                        vim.notify("Enabled indentation guides")
                    else
                        vim.notify("Disabled indentation guides")
                    end
                end,
                desc = "Toggle Indention Guides",
            },
        },
        opts = {
            enabled = false,
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
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            indent = {
                enabled = false,
            },
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
                },
            },
            lazygit = {
                config = {
                    os = {
                        edit = lazygit_edit_command,
                        editAtLine = lazygit_edit_at_line_command,
                        editAtLineAndWait = "nvim +{{line}} {{filename}}",
                        openDirInEditor = '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
                    },
                },
            },
        },
        keys = {
            {
                "<leader>gg",
                function()
                    open_lazygit_with_tracked_window()
                end,
                desc = "Lazygit",
            },
            {
                "<leader>gb",
                function()
                    Snacks.git.blame_line()
                end,
                desc = "[G]it [B]lame",
            },
            {
                "<leader>b.",
                function()
                    Snacks.scratch()
                end,
                desc = "New Scratch [b]uffer",
            },
            {
                "<leader>bS",
                function()
                    Snacks.scratch.select()
                end,
                desc = "Scratch [b]uffer [S]elect",
            },
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
            { "<leader>wm", "<Cmd>WindowsMaximize<CR>", desc = "Maximize window (toggle)" },
            { "<leader>wh", "<Cmd>WindowsMaximizeHorizontally<CR>", desc = "Maximize window horizontally" },
            { "<leader>wv", "<Cmd>WindowsMaximizeVertically<CR>", desc = "Maximize window vertically" },
            { "<leader>we", "<Cmd>WindowsEqualize<CR>", desc = "Equalize windows" },
            { "<leader>wa", "<Cmd>WindowsToggleAutowidth<CR>", desc = "Toggle window autowidth" },
            { "<C-w>a", "<Cmd>WindowsToggleAutowidth<CR>", desc = "Toggle window autowidth" },
            {
                "<leader>ww",
                "<C-W>p",
                desc = "Other Window",
                remap = true,
            },
            {
                "<leader>wd",
                "<C-W>c",
                desc = "Delete Window",
                remap = true,
            },
        },
    },
    {
        "cosmicbuffalo/updater.nvim",
        event = "VimEnter", -- Needs to be loaded early so that it can check for updates on startup
        opts = {
            keymap = {
                open = "<leader>e",
            },
            check_updates_on_startup = { enabled = false }, -- disable update checks by default
            periodic_check = {
                enabled = false, -- disable update checks by default
                frequency_minutes = 120,
            },
            excluded_filetypes = { "gitcommit", "gitrebase" },
        },
        cmd = { "UpdaterOpen", "UpdaterCheck", "UpdaterStartChecking", "UpdaterStopChecking" },
        keys = {
            { "<leader>e", "<Cmd>UpdaterOpen<CR>", desc = "Open Updater" },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        enabled = false, -- toggle this on if you're interested in using live markdown preview (requires some additional setup)
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install", -- If this isn't working, try the below command manually
        -- `cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app && npm install`
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_browserfunc = "CopyToClipboard"
            vim.g.mkdp_port = "9049" -- Need to forward this port in .cpair.conf
            -- Copying the preview server's URL to clipboard is the only way to get to it over SSH
            -- Set up a clipboard watching script to open copied URLs in the browser automatically
            -- See example script here: https://gist.github.com/cosmicbuffalo/60a70e15ace8961b9bb11e9206363ec8
            function _G.CopyToClipboard(url)
                vim.fn.setreg("+", url)
                vim.notify(
                    "Markdown Preview URL copied to clipboard: " .. url,
                    vim.log.levels.INFO,
                    { title = "Markdown Preview" }
                )
            end
            -- This plugin is written in Vimscript, so we need to call this function from Vimscript as well
            vim.cmd([[
				function! CopyToClipboard(url)
				  call luaeval('_G.CopyToClipboard(_A)', a:url)
				endfunction
			]])
        end,
        ft = { "markdown" },
        keys = {
            { "<leader>mp", ":MarkdownPreview<CR>", desc = "Start Markdown Preview" },
            { "<leader>ms", ":MarkdownPreviewStop<CR>", desc = "Stop Markdown Preview" },
            { "<leader>mt", ":MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
        },
    },
    {
        "ruifm/gitlinker.nvim",
        keys = {
            {
                "<leader>gy",
                function()
                    require("gitlinker").get_buf_range_url("n")
                end,
                desc = "Copy GitHub link",
                mode = { "n" },
            },
            {
                "<leader>gy",
                function()
                    require("gitlinker").get_buf_range_url("v")
                end,
                desc = "Copy GitHub link",
                mode = { "v" },
            },
            {
                "<leader>gY",
                function()
                    require("gitlinker").get_repo_url()
                end,
                desc = "Copy GitHub Repo link",
            },
        },
    },
    {
        "cosmicbuffalo/super_lazy.nvim",
        lazy = false,
        opts = {
            lockfile_repo_dirs = {
                vim.fn.stdpath("config"),
                vim.fn.stdpath("config") .. "/lua/personal",
            },
            silent = true, -- suppresses fidget displays
        },
    },
    {
        "cosmicbuffalo/root_swapper.nvim",
    },

    {
        -- provides indentation-related textobjects
        -- try it out with `vai` or `vii`
        "nvim-mini/mini.indentscope",
        version = "*",
        event = "VeryLazy",
        init = function()
            -- this globally disables the highlighting feature of the plugin
            vim.g.miniindentscope_disable = true
        end,
        opts = {},
    },
}
