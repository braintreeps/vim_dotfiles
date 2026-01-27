local Utils = require("config.utils")
-- TreeSitter: advanced syntax highlighting and plugins that use Treesitter parsers

-- TODO expose this as a configurable value
local treesitter_highlight_max_file_size = 150 -- Kilobytes

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        priority = 1000,
        branch = "main",
        build = function()
            local TS = require("nvim-treesitter")
            if not TS.get_installed then
                vim.notify(
                    "Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.",
                    vim.log.levels.ERROR
                )
                return
            end
            Utils.treesitter.build(function()
                TS.update(nil, { summary = true })
            end)
        end,
        event = { "VeryLazy" },
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        dependencies = {
            "mason-org/mason.nvim",
            "RRethy/nvim-treesitter-endwise",
            { "andymass/vim-matchup", opts = {}, lazy = false },
        },
        opts_extend = { "ensure_installed" },
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "ruby" }, -- TODO: confirm still needed
                disable = function(_lang, buffer)
                    local max_filesize = treesitter_highlight_max_file_size * 1024 -- convert actual kilobytes
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buffer))

                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            incremental_selection = {
                enable = true,
            },
            indent = {
                enable = true,
                disable = { "ruby" }, -- TODO: confirm still needed
            },
            endwise = {
                enable = true,
            },
            ensure_installed = Utils.treesitter.ensure_installed,
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter")

            -- Patch treesitter logger to use fidget directly
            local ok, log = pcall(require, "nvim-treesitter.log")
            if ok and log then
                local fidget = require("fidget.notification")
                local original_new = log.new

                log.new = function(ctx)
                    local logger = original_new(ctx)
                    local prefix = "[nvim-treesitter/" .. ctx .. "]"

                    logger.info = function(self, fmt, ...)
                        fidget.notify(prefix .. ": " .. string.format(fmt, ...), vim.log.levels.INFO, {
                            group = "treesitter",
                            annote = ctx,
                        })
                    end
                    logger.warn = function(self, fmt, ...)
                        fidget.notify(prefix .. " warning: " .. string.format(fmt, ...), vim.log.levels.WARN, {
                            group = "treesitter",
                            annote = ctx,
                        })
                    end
                    logger.error = function(self, fmt, ...)
                        fidget.notify(prefix .. " error: " .. string.format(fmt, ...), vim.log.levels.ERROR, {
                            group = "treesitter",
                            annote = ctx,
                        })
                    end

                    return logger
                end

                -- Patch module-level log functions too
                local module_prefix = "[nvim-treesitter]"
                log.info = function(fmt, ...)
                    fidget.notify(module_prefix .. ": " .. string.format(fmt, ...), vim.log.levels.INFO, {
                        group = "treesitter",
                        annote = "install",
                    })
                end
                log.warn = function(fmt, ...)
                    fidget.notify(module_prefix .. " warning: " .. string.format(fmt, ...), vim.log.levels.WARN, {
                        group = "treesitter",
                        annote = "install",
                    })
                end
                log.error = function(fmt, ...)
                    fidget.notify(module_prefix .. " error: " .. string.format(fmt, ...), vim.log.levels.ERROR, {
                        group = "treesitter",
                        annote = "install",
                    })
                end
            end

            setmetatable(require("nvim-treesitter.install"), {
                __newindex = function(_, k)
                    if k == "compilers" then
                        vim.schedule(function()
                            vim.notify({
                                "Setting custom compilers for `nvim-treesitter` is no longer supported.",
                                "",
                                "For more info, see:",
                                "- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)",
                            }, vim.log.levels.ERROR)
                        end)
                    end
                end,
            })

            -- some quick sanity checks
            if not TS.get_installed then
                return vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.ERROR)
            elseif type(opts.ensure_installed) ~= "table" then
                return vim.notify("`nvim-treesitter` opts.ensure_installed must be a table", vim.log.levels.ERROR)
            end

            -- setup treesitter
            TS.setup(opts)
            Utils.treesitter.get_installed(true) -- initialize the installed langs

            -- install missing parsers
            local install = vim.tbl_filter(function(lang)
                return not Utils.treesitter.have(lang)
            end, opts.ensure_installed or {})
            if #install > 0 then
                Utils.treesitter.build(function()
                    TS.install(install, { summary = true }):await(function()
                        Utils.treesitter.get_installed(true) -- refresh the installed langs
                    end)
                end)
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter_group", { clear = true }),
                callback = function(ev)
                    local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
                    if not Utils.treesitter.have(ft) then
                        return
                    end

                    ---@param feat string
                    ---@param query string
                    local function enabled(feat, query)
                        local f = opts[feat] or {}
                        return f.enable ~= false
                            and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
                            and Utils.treesitter.have(ft, query)
                    end

                    -- highlighting
                    if enabled("highlight", "highlights") then
                        pcall(vim.treesitter.start)
                    end
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        opts = {
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                keys = {
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]A"] = "@parameter.inner",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner",
                    },
                },
            },
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter-textobjects")
            if not TS.setup then
                vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.ERROR)
                return
            end
            TS.setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("custom_treesitter_textobjects", { clear = true }),
                callback = function(ev)
                    local moves = vim.tbl_get(opts, "move", "keys") or {}

                    for method, keymaps in pairs(moves) do
                        for key, query in pairs(keymaps) do
                            local desc = query:gsub("@", ""):gsub("%..*", "")
                            desc = desc:sub(1, 1):upper() .. desc:sub(2)
                            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
                            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
                            if not (vim.wo.diff and key:find("[cC]")) then
                                vim.keymap.set({ "n", "x", "o" }, key, function()
                                    require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
                                end, {
                                    buffer = ev.buf,
                                    desc = desc,
                                    silent = true,
                                })
                            end
                        end
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPost",
        opts = {
            mode = "cursor",
            max_lines = 6,
            multiline_threshold = 3,
            trim_scope = "inner",
            -- Upper block separators (not great because of the background and indent guides)
            -- separator = "▔", -- 1/8
            -- separator = "▀", -- 1/2

            -- Lower block separators
            separator = "▁", -- 1/8
            -- separator = "▂", -- 1/4
            -- separator = "▃", -- 3/8
            -- separator = "▄", -- 1/2
            -- separator = "▅", -- 5/8

            -- Full height separator
            -- separator = "█",
        },
        keys = {
            {
                "<leader>ut",
                function()
                    local tsc = require("treesitter-context")
                    tsc.toggle()
                    if tsc.enabled() then
                        vim.notify("Enabled Treesitter Context", vim.log.levels.INFO)
                    else
                        vim.notify("Disabled Treesitter Context", vim.log.levels.WARN)
                    end
                end,
                desc = "Toggle Treesitter Context",
            },
        },
    },
}
