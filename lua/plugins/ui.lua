-- UI: Enhance the user interface with features such as status line, buffer line, indentation guides, dashboard, and icons.

local SwitchColorschemeKeyMap = require("lazy_utils").SwitchColorschemeKeyMap

-- cache results of rev-parse
local is_inside_work_tree = {}

function vim.find_files_from_project_git_root()
  local opts = {} -- define here if you want to define something

  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system("git rev-parse --is-inside-work-tree")
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    require("telescope.builtin").git_files(opts)
  else
    require("telescope.builtin").find_files(opts)
  end
end

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
			{ "<Leader><Leader>", "<cmd>lua vim.find_files_from_project_git_root()<CR>", desc = "Find files" },
			{ "<Leader>ff", "<cmd>lua vim.find_files_from_project_git_root()<CR>", desc = "Find files" },
			{ "<C-p>", "<cmd>lua vim.find_files_from_project_git_root()<CR>", desc = "Find files" },
			{ "<Leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find (grep)" },
			{ "<Leader>be", "<cmd>Telescope buffers<CR>", desc = "Buffer Explorer" },
			{ "<Leader>gw", "<cmd>Telescope grep_string<CR>", desc = "Grep word in cursor" },
			{ "<Leader>fh", "<cmd>Telescope man_pages<CR>", desc = "Find help pages" },
			{ "<Leader>fm", "<cmd>Telescope keymaps<CR>", desc = "Find keymappings" },
			SwitchColorschemeKeyMap,
		},
		opts = {
			defaults = {
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = 'top',
					horizontal = {
						width = { padding = 0 },
						height = { padding = 0 },
                       preview_width = 0.5
					},
				},
			},
			pickers = {
				live_grep = {
					file_ignore_patterns = { "node_modules", ".git", "**/*.rbi" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				find_files = {
					file_ignore_patterns = { "node_modules", ".git", "**/*.rbi" },
					hidden = true,
				},
			},
		},
	},
}
