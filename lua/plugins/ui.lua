-- UI: Enhance the user interface with features such as status line, buffer line, indentation guides, dashboard, and icons.
local Utils = require("config.utils")

local git_root_cache = {}

-- Find files from project root (git root if available, otherwise current directory)
local function find_files_from_project_git_root()
    local opts = Utils.lazy.opts("telescope.nvim").pickers.find_files or {}
    local cwd = vim.fn.getcwd()

    local cache_key = cwd
    if git_root_cache[cache_key] == nil then
        local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
        if vim.v.shell_error == 0 and git_root ~= "" and vim.fn.isdirectory(git_root) == 1 then
            git_root_cache[cache_key] = { is_git = true, root = git_root }
        else
            git_root_cache[cache_key] = { is_git = false, root = cwd }
        end
    end

    local cache_entry = git_root_cache[cache_key]
    local search_opts = vim.tbl_deep_extend("force", opts, { cwd = cache_entry.root })

    if cache_entry.is_git then
        require("telescope.builtin").git_files(search_opts)
    else
        require("telescope.builtin").find_files(search_opts)
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
        sort_mru = true,
        initial_mode = "normal",
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
                        local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)),
                            "&Yes\n&No\n&Cancel")
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
        "folke/noice.nvim",
        enabled = false, -- turn this on in your neovim-dotfiles-personal to enable fancy command and search lines, plus command visualization in the lualine
        dependencies = { "rcarriga/nvim-notify" },
        event = "VeryLazy",
        opts = {
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        enabled = false, -- turn this on in your neovim-dotfiles-personal to enable toast-like notifications in the top right corner of neovim
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss All Notifications",
            },
            {
                "<leader>uh",
                function()
                    require("telescope").extensions.notify.notify()
                end,
                desc = "Notification History",
            },
        },
        opts = {
            stages = "static",
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                opts = {
                    override_by_filename = {
                        ["rakefile"] = {
                            icon = "",
                            color = "#ff4f3f",
                            cterm_color = "52",
                            name = "Rakefile",
                        },
                        ["Gemfile"] = {
                            icon = "",
                            color = "#ff4f3f",
                            cterm_color = "52",
                            name = "Rakefile",
                        },
                    },
                    override_by_extension = {
                        ["config.ru"] = {
                            icon = "",
                            color = "#ff4f3f",
                            cterm_color = "52",
                            name = "ConfigRu",
                        },
                        ["rb"] = {
                            icon = "",
                            color = "#ff4f3f",
                            cterm_color = "52",
                            name = "Rb",
                        },
                    },
                },
            },
            "AndreM222/copilot-lualine",
        },
        opts = function()
            -- NOTE: This isn't personalizable without duplicating the entire function
            local utils = require("lualine.utils.utils")
            local highlight = require("lualine.highlight")
            local conf = require("lualine").get_config()
            local diagnostics_message = require("lualine.component"):extend()

            diagnostics_message.default = {
                colors = {
                    error = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticError" }, "#e32636"),
                    warning = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticWarn" }, "#ffa500"),
                    info = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticInfo" }, "#ffffff"),
                    hint = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticHint" }, "#273faf"),
                },
            }
            function diagnostics_message:init(options)
                diagnostics_message.super:init(options)
                self.options.colors =
                    vim.tbl_extend("force", diagnostics_message.default.colors, self.options.colors or {})
                self.highlights = { error = "", warn = "", info = "", hint = "" }
                self.highlights.error = highlight.create_component_highlight_group(
                    { fg = self.options.colors.error },
                    "diagnostics_message_error",
                    self.options
                )
                self.highlights.warn = highlight.create_component_highlight_group(
                    { fg = self.options.colors.warn },
                    "diagnostics_message_warn",
                    self.options
                )
                self.highlights.info = highlight.create_component_highlight_group(
                    { fg = self.options.colors.info },
                    "diagnostics_message_info",
                    self.options
                )
                self.highlights.hint = highlight.create_component_highlight_group(
                    { fg = self.options.colors.hint },
                    "diagnostics_message_hint",
                    self.options
                )
            end

            function diagnostics_message:update_status(_is_focused)
                local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
                local diagnostics = vim.diagnostic.get(0, { lnum = r - 1 })
                if #diagnostics > 0 then
                    table.sort(diagnostics, function(a, b)
                        if a.col == b.col then
                            return a.severity < b.severity
                        else
                            return a.col < b.col
                        end
                    end)

                    local icons = { "󰅚 ", "󰀪 ", "󰋽 ", "󰌶 " }
                    local hl =
                        { self.highlights.error, self.highlights.warn, self.highlights.info, self.highlights.hint }

                    local messages = {}
                    for _, diag in ipairs(diagnostics) do
                        -- Take only the first line of multi-line diagnostic messages
                        local first_line = diag.message:match("^[^\r\n]*")
                        local msg = icons[diag.severity] .. (diag.col + 1) .. ": " .. first_line
                        table.insert(messages, msg)
                    end

                    -- Use the most severe diagnostic's highlight for the entire string
                    local most_severe = diagnostics[1]
                    return highlight.component_format_highlight(hl[most_severe.severity])
                        .. table.concat(messages, "  ")
                else
                    return ""
                end
            end

            local updater_component = {
                function()
                    return require("updater").status.get_update_text("icon")
                end,
                cond = function()
                    return require("updater").status.has_updates()
                end,
                color = function()
                    local status = require("updater").status.get()
                    -- Different colors based on update type
                    if status.needs_update and status.has_plugin_updates then
                        return { fg = "#f7768e" } -- Red for both types
                    elseif status.needs_update then
                        return { fg = "#ff9e64" } -- Orange for dotfiles
                    else
                        return { fg = "#9ece6a" } -- Green for plugins only
                    end
                end,
                on_click = function()
                    require("updater").open()
                end,
            }

            local new_conf = vim.tbl_deep_extend("force", conf, {
                theme = "inkline",
                sections = {
                    lualine_c = {
                        {
                            "filetype",
                            icon_only = true,
                            separator = { right = "" },
                            padding = { left = 1, right = 0 },
                        },
                        {
                            "filename",
                            path = 1,
                            separator = { left = "" },
                            padding = { left = 0 },
                        },
                        {
                            diagnostics_message,
                            colors = {
                                error = "#e32636",
                                warn = "#ffa500",
                                -- info = "#ffffff",
                                -- hint = "#273faf",
                            },
                            fmt = function(str)
                                local max_width = vim.o.columns - 80
                                if #str > max_width then
                                    return str:sub(1, max_width - 3) .. "..."
                                end
                                return str
                            end,
                        },
                    },
                    lualine_x = {
                        {
                            function()
                                local ok, noice = pcall(require, "noice")
                                if ok then
                                    return noice.api.status.command.get()
                                end
                                return ""
                            end,
                            cond = function()
                                local ok, noice = pcall(require, "noice")
                                return ok and noice.api.status.command.has()
                            end,
                            color = { fg = "#ff9e64" },
                        },
                        {
                            function()
                                local reg = vim.fn.reg_recording()
                                if reg == "" then
                                    return ""
                                else
                                    return "recording @" .. reg
                                end
                            end,
                            color = { fg = "yellow" },
                        },
                        {
                            "searchcount",
                            color = { fg = "cyan" },
                        },
                        {
                            "copilot",
                            padding = { left = 1, right = 0 },
                        },
                        updater_component,
                        -- "lsp_status"
                    },
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
            { "<Leader><Leader>", "<cmd>Telescope find_files<CR>",                desc = "Find files" },
            { "<C-p>",            function() find_files_from_project_git_root() end,  desc = "Find (git) files" },
            { "<Leader>be",       function() OpenBufferExplorer() end,            desc = "Buffer Explorer" },
            { "<Leader>gw",       "<cmd>Telescope grep_string<CR>",               desc = "Grep word in cursor" },
            Utils.colors.SwitchColorschemeKeyMap,
            -- "find" keymaps
            { "<Leader>ff",       function() find_files_from_project_git_root() end,  desc = "Find (git) files" },
            { "<Leader>fg",       "<cmd>Telescope live_grep<CR>",                 desc = "Find (grep)" },
            { "<Leader>fb",       function() OpenBufferExplorer() end,            desc = "Find Buffers" },
            { "<Leader>fr",       "<cmd>Telescope oldfiles<CR>",                  desc = "Find Recent" },
            { "<Leader>fh",       "<cmd>Telescope man_pages<CR>",                 desc = "Find help pages" },
            { "<Leader>fm",       "<cmd>Telescope marks<CR>",                     desc = "Find marks" },
            { "<Leader>fd",       "<cmd>Telescope diagnostics bufnr=0<CR>",       desc = "Document Diagnostics" },
            { "<Leader>fD",       "<cmd>Telescope diagnostics<CR>",               desc = "Workspace Diagnostics" },
            { "<Leader>fp",       function() OpenPluginExplorer() end,            desc = "Find Plugin File" },
            -- "search" keymaps
            { "<Leader>sk",       "<cmd>Telescope keymaps<CR>",                   desc = "Keymaps" },
            { '<Leader>s"',       "<cmd>Telescope registers<CR>",                 desc = "Registers" },
            { "<Leader>sa",       "<cmd>Telescope autocommands<CR>",              desc = "Auto commands" },
            { "<Leader>sg",       "<cmd>Telescope live_grep<CR>",                 desc = "Grep" },
            { "<Leader>sb",       "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Fuzzy Find" },
            { "<Leader>sh",       "<cmd>Telescope help_tags<CR>",                 desc = "Help Pages" },
            { "<Leader>sC",       "<cmd>Telescope commands<CR>",                  desc = "Commands" },
            { "<Leader>sc",       "<cmd>Telescope command_history<CR>",           desc = "Command History" },
            { "<Leader>so",       "<cmd>Telescope vim_options<CR>",               desc = "Options" },
            { "<Leader>sw",       "<cmd>Telescope grep_string<CR>",               desc = "Word under cursor" },
            { "<Leader>sw",       "<cmd>Telescope grep_string<CR>",               mode = "v",                        desc = "Selection" },
            { "<Leader>sr",       "<cmd>Telescope resume<CR>",                    desc = "Resume" },
        },
        opts = {
            defaults = {
                file_ignore_patterns = {
                    "node_modules/",
                    ".git/refs/",
                    ".git/logs",
                    ".git/objects",
                    "sorbet/rbi/annotations/",
                    "sorbet/rbi/dsl/",
                    "sorbet/rbi/gems/",
                },
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                    horizontal = {
                        width = {
                            padding = function(_self, max_columns, _max_lines)
                                -- On small terminals it's not worth spending
                                -- space on the context of behind the picker, so
                                -- make it full width.
                                --
                                -- But on larger terminals, it's desirable to
                                -- show context so that people don't lose track
                                -- of where they were. For example, it makes it
                                -- easier to see what pane you trigger the
                                -- picker from and treat the picker as a modal.
                                -- Otherwise with the picker's split list/preview
                                -- it's easy for the picker (e.g., when
                                -- triggered from a right pane) to feel like
                                -- you've been moved to the left pane, and then
                                -- when a file/buffer is selected it's visually
                                -- jarring/confusing when you end back up in the
                                -- right pane.
                                if max_columns <= 80 then
                                    return 0
                                else
                                    return math.ceil(max_columns * 0.04 + 2)
                                end
                            end,
                        },
                        height = {
                            padding = function(_self, _max_columns, max_lines)
                                -- On small terminals it's not worth spending
                                -- space on the context of behind the picker, so
                                -- make it full height.
                                --
                                -- But on larger terminals, it's desirable to
                                -- show context so that people don't lose track
                                -- of where they were.
                                if max_lines <= 30 then
                                    return 0
                                else
                                    return math.ceil(max_lines * 0.03 + 2)
                                end
                            end,
                        },
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
                            end,
                        },
                    },
                },
                find_files = {
                    hidden = true,
                    mappings = {
                        i = {
                            ["<C-t>"] = function(prompt_bufnr)
                                scope_to_dir(prompt_bufnr, require("telescope.builtin").find_files)
                            end,
                        },
                    },
                },
                git_files = {
                    show_untracked = true,
                    hidden = true,
                    mappings = {
                        i = {
                            ["<C-t>"] = function(prompt_bufnr)
                                scope_to_dir(prompt_bufnr, require("telescope.builtin").find_files) -- intentional move to find_files to respect cwd option
                            end,
                        },
                    },
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
        end,
    },
    {
        "rebelot/heirline.nvim",
        lazy = false,
        dependencies = {
            "nvim-lualine/lualine.nvim",
            "nvim-tree/nvim-web-devicons",
            {
                "Bekaboo/dropbar.nvim",
                lazy = false,
                opts = {
                    menu = {
                        -- turn this off to disable dynamic preview on menu movement
                        -- dynamic previews can also be toggled per source (see below)
                        -- preview = false,
                    },
                    bar = {
                        -- turn off the automatic attachment behavior since it'll be
                        -- handled by the component in heirline
                        enable = false,
                        sources = function(buf, _)
                            local utils = require("dropbar.utils")
                            local sources = require("dropbar.sources")
                            if vim.bo[buf].ft == "oil" then
                                return {
                                    sources.path,
                                }
                            end
                            if vim.bo[buf].ft == "markdown" then
                                return {
                                    sources.path,
                                    sources.markdown,
                                }
                            end
                            if vim.bo[buf].buftype == "terminal" then
                                return {
                                    sources.terminal,
                                }
                            end
                            return {
                                sources.path,
                                utils.source.fallback({
                                    sources.lsp,
                                    -- sources.treesitter,
                                }),
                            }
                        end,
                    },
                    sources = {
                        path = {
                            -- Preview is turned off by default for the path source
                            preview = false,
                            -- This customizes the path source for oil buffers
                            -- oil buffers will show the path relative to the
                            -- git root, if available
                            relative_to = function(buf, win)
                                local bufname = vim.api.nvim_buf_get_name(buf)
                                if vim.startswith(bufname, "oil://") then
                                    local full_path = bufname:gsub("^%S+://", "", 1)
                                    local git_root =
                                        vim.fs.find(".git", { upward = true, path = full_path, type = "directory" })
                                    if git_root and #git_root > 0 then
                                        local git_dir = vim.fs.dirname(git_root[1])
                                        return vim.fs.dirname(git_dir)
                                    end
                                end

                                local ok, cwd = pcall(vim.fn.getcwd, win)
                                return ok and cwd or vim.fn.getcwd()
                            end,
                        },
                        lsp = {
                            valid_symbols = {
                                -- Customize this list to control what can show
                                -- up as breadcrumbs in the dropbar winbar
                                -- for lsp source
                                "Module",
                                "Namespace",
                                "Class",
                                "Method",
                                "Function",
                                "Constructor",
                                "Array",
                                "Object",
                            },
                        },
                        treesitter = {
                            valid_types = {
                                -- TODO: This filtering doesn't actually work
                                -- Customize this list to control what can show
                                -- up as breadcrumbs in the dropbar winbar for
                                -- treesitter source
                                "class",
                                "constructor",
                                "do_statement",
                                "function",
                                "if_statement",
                                "method",
                                "namespace",
                                "table",
                                "type",
                                "object",
                            },
                        },
                    },
                    icons = {
                        -- Icons for dropbar can be customized here
                        ui = {
                            bar = {
                                -- separator = " > ",
                                separator = "  ",
                                extends = "…",
                            },
                            menu = {
                                -- indicator = "> ",
                                indicator = " ",
                                separator = " ",
                            },
                        },
                    },
                },
                keys = {
                    {
                        "<leader>bo",
                        function()
                            require("dropbar.api").pick()
                        end,
                        desc = "Drop[b]ar - [O]pen Picker",
                    },
                },
            },
        },
        opts = {
            winbar_disabled_buftypes = { "nofile", "prompt", "help", "quickfix", "terminal" },
            winbar_disabled_filetypes = {
                "^git.*",
                "fugitive",
                "Trouble",
                "dashboard",
                "neo-tree",
                "which-key",
                "lazygit",
            },
            -- toggle this to remove the mode wapper on active winbar
            enable_mode_wrapper = true,
            -- customize mode color assignments here
            -- (settings for inkline or tokyonight are automatically applied)
            mode_colors = Utils.colors.get_mode_colors,
            -- customize heirline color mappings to colorscheme highlights here
            -- (settings for inkline or tokyonight are automatically applied)
            color_highlight_mappings = Utils.colors.get_highlight_mappings,
            inactive_color = "#1e2124",
        },
        config = function(_, opts)
            local heirline_config = require("config.heirline")
            local setup_colors = function()
                return Utils.colors.setup_heirline_colors(opts)
            end
            require("heirline").load_colors(setup_colors)

            vim.api.nvim_create_augroup("Heirline", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    local utils = require("heirline.utils")
                    utils.on_colorscheme(setup_colors)
                end,
                group = "Heirline",
            })

            require("heirline").setup({
                winbar = heirline_config.build_winbar(opts),
                opts = heirline_config.build_opts(opts),
            })
        end,
        keys = {
            {
                "<leader>uW",
                function()
                    require("config.heirline").toggle_winbar()
                end,
                desc = "Toggle [U]I [W]inbar",
            },
        },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        build = "make",
        config = function(_, _opts)
            require("telescope").load_extension("fzf")
        end,
    },
}
