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
			"echasnovski/mini.bufremove",

		},
		keys = {
			{ "<Leader><Leader>", "<cmd>lua vim.find_files_from_project_git_root()<CR>", desc = "Find files" },
			{ "<Leader>ff", "<cmd>lua vim.find_files_from_project_git_root()<CR>", desc = "Find files" },
			{ "<C-p>", "<cmd>lua vim.find_files_from_project_git_root()<CR>", desc = "Find files" },
			{ "<Leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find (grep)" },
			{
				"<Leader>be",
				function()
					require("telescope.builtin").buffers({
						attach_mappings = function(prompt_bufnr, map)
							local action_state = require("telescope.actions.state")
							local bd = require("mini.bufremove").delete
							local delete_buffer = function()
								local current_picker = action_state.get_current_picker(prompt_bufnr)
								current_picker:delete_selection(function(selection)
									local bufnr = selection.bufnr
									local force = vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal"
									if force then
										return pcall(vim.api.nvim_buf_delete, bufnr, { force = force })
									elseif vim.fn.getbufvar(bufnr, "&modified") == 1 then
										local choice =
										vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)), "&Yes\n&No\n&Cancel")
										if choice == 1 then -- Yes
											vim.api.nvim_buf_call(bufnr, function()
												vim.cmd("write")
											end)
											return bd(bufnr)
										elseif choice == 2 then -- No
											return bd(bufnr, true)
										end
									else
										return bd(bufnr)
									end
								end)
							end
							map("n", "d", delete_buffer)
							return true
						end,
					})
				end,
				desc = "Buffer Explorer"
			},
			{ "<Leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Find Recent" },
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
