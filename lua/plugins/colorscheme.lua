-- Colorscheme: Default color schemes (TokyoNight and Catppuccin).

-- Users may change colorscheme via \uC. This choice persists locally.
local SwitchColorschemeKeyMap = require("lazy_utils").SwitchColorschemeKeyMap

return {
	-- Util for persisting chosen colorscheme
	{
		"tingey21/telescope-colorscheme-persist.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		lazy = false,
		opts = {},
	},
	-- Schemes
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			transparent_background = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
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
		lazy = false,
		config = function(_, opts)
			require("inkline").setup(opts)
			vim.cmd.colorscheme("inkline")
		end,
	},
}
