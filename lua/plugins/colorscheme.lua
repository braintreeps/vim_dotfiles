-- Colorscheme: Default color schemes (TokyoNight and Catppuccin).

-- Users may change colorscheme via \uC. This choice persists locally.
local Utils = require("config.utils")
local SwitchColorschemeKeyMap = Utils.colors.SwitchColorschemeKeyMap

---@module "lazy"
---@type LazyPluginSpec[]
return {
    -- Util for persisting chosen colorscheme
    {
        "tingey21/telescope-colorscheme-persist.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = false,
        opts = {
            -- The default keybind needs to be disabled to avoid conflicts with
            -- lazy.nvim's lazy loading behavior using `keys` settings in specs
            keybind = false,
        },
        keys = { SwitchColorschemeKeyMap },
    },
    -- Schemes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        keys = { SwitchColorschemeKeyMap },
        opts = {
            flavour = "mocha",
            transparent_background = true,
        },
    },
    {
        "folke/tokyonight.nvim",
        keys = { SwitchColorschemeKeyMap },
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
    },
    {
        "afair/vibrantink2",
        keys = { SwitchColorschemeKeyMap },
    },
    {
        "shaunsingh/nord.nvim",
        name = "nord.nvim",
        keys = { SwitchColorschemeKeyMap },
    },
    {
        "hectron/inkline.nvim",
        priority = 1000,
        tag = "v2.1.2",
        lazy = false,
        keys = { SwitchColorschemeKeyMap },
        ---@module "inkline.config"
        ---@type inkline.Config
        opts = {
            transparent = true,
            dim_inactive_windows = false,
            purple_comments = true,
            style = "retro",
            on_highlights = function(hl, c)
                hl["@markup.link"] = { fg = c.yellow }
                return hl
            end,
        },
        config = function(_, opts)
            require("inkline").setup(opts)
            vim.cmd.colorscheme("inkline")
        end,
    },
}
