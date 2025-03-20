-- Editor: Provides functionality like a file explorer, search and replace, fuzzy finding, git integration.

local LazyFileEvents = require("lazy_utils").LazyFileEvents

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			spec = {
				{ "<leader>A", group = "Alternate" },
				{ "<leader>a", group = "AI" },
				{ "<leader>f", group = "Find" },
				{ "<leader>n", group = "Neotree" },
				{ "<leader>r", group = "Run tests" },
				{ "<leader>u", group = "UI" },
				{ "<leader>v", group = "Vimux" },
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim", -- Show diffs and more!
		event = LazyFileEvents,
		opts = {},
		keys = {
			{ "<Leader>bl", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "[b]lame [l]ine" },
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
				follow_current_file = { enabled = true },
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
}
