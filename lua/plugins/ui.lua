-- UI: Enhance the user interface with features such as status line, buffer line, indentation guides, dashboard, and icons.
local Utils = require("lazy_utils")
local SwitchColorschemeKeyMap = Utils.SwitchColorschemeKeyMap

-- cache results of rev-parse
local is_inside_work_tree = {}

function vim.find_files_from_project_git_root()
    local opts = Utils.opts("telescope.nvim").pickers.find_files
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

local function OpenPluginExplorer()
    require("telescope.builtin").find_files({
        cwd = require("lazy.core.config").options.root,
        prompt_title = "Plugin Files",
    })
end

local function OpenBufferExplorer()
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
                        -- stylua: ignore
                        local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)), "&Yes\n&No\n&Cancel")
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
end

local function scope_to_dir(prompt_bufnr, picker)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local fb = require("telescope").extensions.file_browser
	local current_line = action_state.get_current_line()

	fb.file_browser({
		files = false,
		depth = false,
		display_stat = { date = false, size = false, mode = false },
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local entry_path = action_state.get_selected_entry().Path
				local dir = entry_path:is_dir() and entry_path or entry_path:parent()
				local relative = dir:make_relative(vim.fn.getcwd())
				local absolute = dir:absolute()

				picker({
					results_title = relative .. "/",
					cwd = absolute,
					default_text = current_line,
				})
			end)

			return true
		end,
	})

end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "AndreM222/copilot-lualine",
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
                    lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
                },
            })

            return new_conf
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                "echasnovski/mini.bufremove",
                keys = {
                    {
                        "<leader>bd",
                        function()
                            local bd = require("mini.bufremove").delete
                            if vim.bo.modified then
                                local choice = vim.fn.confirm(
                                    ("Save changes to %q?"):format(vim.fn.bufname()),
                                    "&Yes\n&No\n&Cancel"
                                )
                                if choice == 1 then -- Yes
                                    vim.cmd.write()
                                    bd(0)
                                elseif choice == 2 then -- No
                                    bd(0, true)
                                end
                            else
                                bd(0)
                            end
                        end,
                        desc = "Delete Buffer",
                    },
					-- stylua: ignore
					{ "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
                },
            },
        },
        -- stylua: ignore
        keys = {
            -- Misc keymaps
            { "<Leader><Leader>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
            { "<C-p>", vim.find_files_from_project_git_root, desc = "Find (git) files" },
            { "<Leader>be", function() OpenBufferExplorer() end, desc = "Buffer Explorer" },
            { "<Leader>gw", "<cmd>Telescope grep_string<CR>", desc = "Grep word in cursor" },
            SwitchColorschemeKeyMap,
            -- "find" keymaps
            { "<Leader>ff", vim.find_files_from_project_git_root, desc = "Find (git) files" },
            { "<Leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find (grep)" },
            { "<Leader>fb", function() OpenBufferExplorer() end, desc = "Find Buffers" },
            { "<Leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Find Recent" },
            { "<Leader>fh", "<cmd>Telescope man_pages<CR>", desc = "Find help pages" },
            { "<Leader>fm", "<cmd>Telescope marks<CR>", desc = "Find marks" },
            { "<Leader>fd", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Document Diagnostics" },
            { "<Leader>fD", "<cmd>Telescope diagnostics<CR>", desc = "Workspace Diagnostics" },
            { "<Leader>fp", function() OpenPluginExplorer() end, desc = "Find Plugin File" },
            -- "search" keymaps
            { "<Leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
            { '<Leader>s"', "<cmd>Telescope registers<CR>", desc = "Registers" },
            { "<Leader>sa", "<cmd>Telescope autocommands<CR>", desc = "Auto commands" },
            { "<Leader>sg", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
            { "<Leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Fuzzy Find" },
            { "<Leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help Pages" },
            { "<Leader>sC", "<cmd>Telescope commands<CR>", desc = "Commands" },
            { "<Leader>sc", "<cmd>Telescope command_history<CR>", desc = "Command History" },
            { "<Leader>so", "<cmd>Telescope vim_options<CR>", desc = "Options" },
            { "<Leader>sw", "<cmd>Telescope grep_string<CR>", desc = "Word under cursor" },
            { "<Leader>sw", "<cmd>Telescope grep_string<CR>", mode = "v", desc = "Selection" },
            { "<Leader>sr", "<cmd>Telescope resume<CR>", desc = "Resume" },
        },
        opts = {
            defaults = {
                file_ignore_patterns = { "node_modules/", ".git/refs/", ".git/logs", ".git/objects", "sorbet/rbi/annotations/", "sorbet/rbi/dsl/", "sorbet/rbi/gems/" },
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                    horizontal = {
                        width = { padding = 0 },
                        height = { padding = 0 },
                        preview_width = 0.5,
                    },
                },
            },
            pickers = {
                live_grep = {
                    additional_args = function(_)
                        return { "--hidden" }
                    end,
					mappings = {
						i = {
							["<C-t>"] = function(prompt_bufnr)
								scope_to_dir(prompt_bufnr, require("telescope.builtin").live_grep)
							end
						}
					}
                },
                find_files = {
                    hidden = true,
					mappings = {
						i = {
							["<C-t>"] = function(prompt_bufnr)
								scope_to_dir(prompt_bufnr, require("telescope.builtin").find_files)
							end
						}
					}
				},
				git_files = {
                    show_untracked = true,
					file_ignore_patterns = { "node_modules", ".git", "**/*.rbi" },
					hidden = true,
					mappings = {
						i = {
							["<C-t>"] = function(prompt_bufnr)
								scope_to_dir(prompt_bufnr, require("telescope.builtin").find_files) -- intentional move to find_files to respect cwd option
							end
						}
					}
				},
            },
        },
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function(_, _opts)
            require("telescope").load_extension("ui-select")
        end,
    },
	{
        "nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function(_, _opts)
			require("telescope").load_extension("file_browser")
		end

	},
}
