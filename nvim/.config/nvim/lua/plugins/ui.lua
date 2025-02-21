-- UI: Enhance the user interface with features such as status line, buffer line, indentation guides, dashboard, and icons.

local SwitchColorschemeKeyMap = require("lazy_utils").SwitchColorschemeKeyMap

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
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
				},
			})

			return new_conf
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		keys = {
			{ "<Leader><Leader>", "<cmd>Telescope find_files<CR>" },
			{ "<C-p>", "<cmd>Telescope find_files<CR>" },
			{ "<Leader>fg", "<cmd>Telescope live_grep<CR>" },
			{ "<Leader>be", "<cmd>Telescope buffers<CR>" },
			{ "<Leader>gw", "<cmd>Telescope grep_string<CR>" },
			{ "<Leader>fh", "<cmd>Telescope man_pages<CR>" },
			{ "<Leader>fm", "<cmd>Telescope keymaps<CR>" },
			SwitchColorschemeKeyMap,
		},
		opts = {
			pickers = {
				live_grep = {
					file_ignore_patterns = { "node_modules", ".git" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				find_files = {
					file_ignore_patterns = { "node_modules", ".git" },
					hidden = true,
				},
			},
		},
	},
}
