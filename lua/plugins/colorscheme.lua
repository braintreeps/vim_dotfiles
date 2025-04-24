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
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
		end,
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
		-- Without lazy=false, this scheme doesn't appear in the picker
		lazy = false,
		keys = { SwitchColorschemeKeyMap },
	},
	{
		"shaunsingh/nord.nvim",
		name = "nord.nvim",
		lazy = false,
		keys = { SwitchColorschemeKeyMap },
	},
	{
		"hectron/inkline.nvim",
		keys = { SwitchColorschemeKeyMap },
		config = function()
			vim.cmd.colorscheme("inkline")
		end,
	},
}
