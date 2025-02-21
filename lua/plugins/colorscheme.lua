-- Colorscheme: Default color schemes (TokyoNight and Catppuccin).

-- Allow users to use a key-binding to preview and change theme (for duration of session)
local SwitchColorschemeKeyMap = require("lazy_utils").SwitchColorschemeKeyMap

return {
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
			vim.cmd.colorscheme("catppuccin")
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
		lazy = true,
		keys = { SwitchColorschemeKeyMap },
	},
}
