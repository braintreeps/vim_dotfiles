-- Editor: Provides functionality like a file explorer, search and replace, fuzzy finding, git integration.

local LazyFileEvents = require("config.utils.lazy").LazyFileEvents

return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            spec = {
                { "<leader>A", group = "Alternate" },
                { "<leader>a", group = "AI", mode = { "n", "v" } },
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code / LSP", mode = { "n", "v" } },
                { "<leader>cw", group = "Workspace" },
                { "<leader>d", group = "Diagnostics" },
                { "<leader>f", group = "Find" },
                { "<leader>n", group = "Neotree" },
                { "<leader>r", group = "Run tests" },
                { "<leader>u", group = "UI" },
                { "<leader>v", group = "Vimux", mode = { "n", "v" } },
                { "<leader>s", group = "Search", mode = { "n", "v" } },
                { "<leader>q", group = "Session" },
                { "<leader>g", group = "Git", mode = { "n", "v" } },
                { "<leader>w", group = "Windows" },
                { "<leader>x", group = "Quickfix" },
                { "<leader><tab>", group = "Tabs" },
                { "zj", desc = "Move to next fold" },
                { "zk", desc = "Move to previous fold" },
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim", -- Show diffs and more!
        event = LazyFileEvents,
        opts = {
            current_line_blame = true,
        },
        keys = {
            { "<Leader>bl", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Line Blame" },
            { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Line Blame" },
            { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Next git hunk" },
            { "]h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev git hunk" },
            { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select git hunk", mode = { "o", "x" } },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "[g]it [r]eset hunk" },
            { "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "[g]it [R]eset buffer" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "[g]it [s]tage hunk" },
            { "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", desc = "[g]it [S]tage buffer" },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "[g]it [u]nstage hunk" },
            { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "[g]it [d]iff this" },
            { "<leader>gD", '<cmd>Gitsigns diffthis "~"<CR>', desc = "[g]it [D]iff this ~" },
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
    {
        "stevearc/resession.nvim",
        opts = {},
        lazy = false,
        keys = {
            { "<Leader>qs", "<cmd>SessionSaveWithDefaults<CR>", desc = "Save Session" },
            { "<Leader>ql", "<cmd>SessionLoadWithDefaults<CR>", desc = "Load Session" },
            { "<Leader>qd", "<cmd>SessionDeleteWithDefaults<CR>", desc = "Delete Session" },
        },
        config = function(_, _opts)
            local resession = require("resession")
            -- explicitly disable periodic autosave to be intentional
            resession.setup({
                autosave = {
                    enabled = false,
                },
            })

            local function get_session_name()
                -- let's name it after pwd + git branch
                local name = vim.fn.getcwd()
                local branch = vim.trim(vim.fn.system("git branch --show-current"))
                if vim.v.shell_error == 0 then
                    return name .. ":" .. branch
                else
                    return name
                end
            end

            -- Resession keymaps
            -- Default all session names to pwd + git branch
            vim.api.nvim_create_user_command("SessionSaveWithDefaults", function()
                resession.save(get_session_name())
            end, { desc = "Save session with name set to cwd + git branch" })

            vim.api.nvim_create_user_command("SessionLoadWithDefaults", function()
                resession.load(get_session_name())
            end, { desc = "Load session named for cwd + git branch" })

            vim.api.nvim_create_user_command("SessionDeleteWithDefaults", function()
                resession.delete(get_session_name())
            end, { desc = "Delete session named for cwd + git branch" })
        end,
    },
    {
        "luukvbaal/statuscol.nvim",
        enabled = false, -- Toggle this in your personal dotfiles to enable gutter fold indicators
        lazy = false,
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                relculright = true,
                segments = {
                    { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
                    { text = { " " } },
                    { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                    { text = { " " } },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                },
            })
        end,
    },
    {
        "kevinhwang91/nvim-ufo",
        enabled = false, -- Toggle this in your personal dotfiles to enable pretty folds via treesitter
        dependencies = {
            "kevinhwang91/promise-async",
        },
        lazy = false,
        opts = {
            open_fold_hl_timeout = 400,
            enable_get_fold_virt_text = true,
            enable_next_line_virt_text = false, -- toggle this to enable "next line" virtual text in folds
            align_suffix = true, -- toggle this to remove the padding between the virtual text and the fold suffix
            preview = {
                win_config = {
                    border = { "", "─", "", "", "", "─", "", "" },
                    winblend = 0,
                },
                mappings = {
                    scrollU = "<C-u>",
                    scrollD = "<C-d>",
                    jumpTop = "[",
                    jumpBot = "]",
                },
            },
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,
        },
        keys = {
            -- stylua: ignore
            { "zr", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
            -- stylua: ignore
            { "zm", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
            { "<leader>z", "za", desc = "Toggle fold" },
            -- stylua: ignore
            { "<leader>Z", "<cmd>ToggleFoldsAtCurrentIndentation<cr>", desc = "Toggle folds at current indentation level" },
        },
        config = function(_, opts)
            -- Folding related options need to be set before ufo is loaded
            vim.opt.foldcolumn = "1"
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
            vim.opt.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

            local handler = function(virtText, lnum, endLnum, width, truncate, ctx)
                local newVirtText = {}
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local startLineText = vim.fn.getline(lnum)
                local curlyMatch = startLineText:match("^%s*{%s*$")
                local isOnlyCurlyBrace = curlyMatch ~= nil
                local nextLineLnum = lnum + 1
                local nextLineText = vim.fn.getline(nextLineLnum)
                local blankLineCount = 0
                while nextLineText:match("^%s*$") ~= nil and nextLineLnum <= endLnum - 1 do
                    blankLineCount = blankLineCount + 1
                    nextLineLnum = nextLineLnum + 1
                    nextLineText = vim.fn.getline(nextLineLnum)
                end
                local showNextLine = opts.enable_next_line_virt_text
                    and (isOnlyCurlyBrace or (foldedLines - blankLineCount) <= 2)
                if showNextLine and nextLineText then
                    local nextLineVirtText = ctx.get_fold_virt_text(nextLineLnum)
                    nextLineVirtText[1][1] = nextLineVirtText[1][1]:gsub("^%s+", " ")
                    vim.list_extend(virtText, nextLineVirtText)
                end

                local lastLineVirtText = ctx.get_fold_virt_text(endLnum)
                if not opts.enable_next_line_virt_text or foldedLines - blankLineCount > 2 then
                    lastLineVirtText[1][1] = lastLineVirtText[1][1]:gsub("^%s*", " ... ")
                else
                    lastLineVirtText[1][1] = lastLineVirtText[1][1]:gsub("^%s*", " ")
                end
                vim.list_extend(virtText, lastLineVirtText)

                local suffix = (" 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                if opts.align_suffix then
                    -- stylua: ignore
                    local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
                    suffix = (" "):rep(rAlignAppndx) .. suffix
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            opts["fold_virt_text_handler"] = handler
            local ufo = require("ufo")
            ufo.setup(opts)

            function fold_at_indent_level()
                local bufnr = vim.api.nvim_get_current_buf()
                local current_line = vim.fn.line(".")
                local current_indent = vim.fn.indent(current_line)
                local fold_ranges = ufo.getFolds(bufnr, "treesitter")
                local fold_closed = vim.fn.foldclosed(current_line) ~= -1

                for _, range in pairs(fold_ranges) do
                    if range.startLine then
                        local start_line = range.startLine + 1
                        local start_indent = vim.fn.indent(start_line)

                        if start_indent == current_indent then
                            if fold_closed then
                                vim.api.nvim_command(start_line .. "foldopen")
                            else
                                vim.api.nvim_command(start_line .. "foldclose")
                            end
                        end
                    else
                        print("Invalid range detected: ", vim.inspect(range))
                    end
                end
            end

            vim.api.nvim_create_user_command("ToggleFoldsAtCurrentIndentation", function()
                fold_at_indent_level()
            end, { desc = "Toggle folds at current indentation level" })
        end,
    },
    {
        "jinh0/eyeliner.nvim",
        -- stylua: ignore
        keys = {
            "f", "F", "t", "T",
            { "<leader>uf", "<cmd>ToggleFTHighlighting<cr>", desc = "Toggle f/t highlight" },
        },
        opts = {
            enabled_by_default = false, -- Toggle this to enable by default
            highlight_on_key = true, -- Toggle this to switch to "always on" mode
            dim = false, -- Toggle this to dim other characters on highlight
            primary_highlight_color = "white", -- Customize the jump target color here
            secondary_highlight_color = "red", -- Customize the secondary jump target color here
            disabled_buftypes = { "nofile" }, -- Add disabled buffer types here
            disabled_filetypes = { "NerdTree", "NvimTree", "NeoTree", "neo-tree" }, -- Add disabled file types here
        },
        config = function(_, opts)
            local eyeliner = require("eyeliner")
            eyeliner.setup(opts)

            if not opts.enabled_by_default then
                eyeliner.disable()
            end

            -- stylua: ignore
            vim.api.nvim_set_hl( 0, "EyelinerPrimary", { fg = opts.primary_highlight_color, bold = true, underline = true })
            vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = opts.secondary_highlight_color, underline = true })

            local eyeliner_enabled = require("eyeliner.main")["enabled?"]
            vim.api.nvim_create_user_command("ToggleFTHighlighting", function()
                if eyeliner_enabled() then
                    eyeliner.disable()
                    vim.notify("Disabled f/t higlighting (eyeliner.nvim)")
                else
                    eyeliner.enable()
                    vim.notify("Enabled f/t highlighting (eyeliner.nvim)")
                end
            end, { desc = "Toggle f/t highlighting" })
        end,
    },
}
