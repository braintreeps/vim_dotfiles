-- TreeSitter: advanced syntax highlighting and plugins that use Treesitter parsers

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdateSync",
		event = { "BufNewFile", "BufReadPost" },
		dependencies = {
			"RRethy/nvim-treesitter-endwise",
			"RRethy/vim-illuminate",
		},
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			incremental_selection = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = { "ruby" }, -- ruby indenting doesn't seem to be working yet
			},
			endwise = {
				enable = true,
			},
			textobjects = {
				move = {
					enable = true,
					goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
					goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
					goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
				},
			},
			ensure_installed = {
				"bash",
				"cmake",
				"diff",
				"dockerfile",
				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"go",
				"groovy",
				"hcl",
				"html",
				"http",
				"java",
				"javascript",
				"jq",
				"json",
				"kotlin",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"properties",
				"proto",
				"puppet",
				"python",
				"ruby",
				"rust",
				"sql",
				"ssh_config",
				"terraform",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
		config = function(_, opts)
			local config = require("nvim-treesitter.configs")
			config.setup(opts)
		end,
	},
}
