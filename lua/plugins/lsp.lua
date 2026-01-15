-- LSP: configure the Language Server Protocol (LSP) client.
local Utils = require("config.utils")
local LazyFileEvents = Utils.lazy.LazyFileEvents
local LspConfig = require("config.lsp")

return {
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        opts = {
            notification = {
                window = {
                    winblend = 0, -- transparent background
                },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = LazyFileEvents,
        dependencies = {
            "mason.nvim",
            { "mason-org/mason-lspconfig.nvim", config = function() end },
            "saghen/blink.cmp",
            { "cosmicbuffalo/gem_install.nvim", opts = {} },
        },
        opts = {
            -- customize your keymap here, or disable a keymap by setting it to false
            keymap = {
                go_to_definition = "gd",
                go_to_declaration = "gD",
                go_to_references = "gr",
                go_to_implementation = "gi",
                jump_to_prev_diagnostic = "[d",
                jump_to_next_diagnostic = "]d",

                hover = "K",
                signature_help = "<C-k>",
                toggle_inlay_hints = "gh",

                diagnostic_explain = "<Leader>de",
                diagnostics_to_quickfix = "<leader>dq",
                toggle_diagnostics = "<Leader>dt",

                type_definition = "<Leader>cD",
                document_symbols = "<Leader>cs",
                lsp_rename = "<Leader>cr",
                lsp_code_action = "<Leader>ca",
                lsp_code_format = "<Leader>cf",
                lsp_info = "<Leader>ci",

                workspace_add_folder = "<Leader>cwa",
                workspace_remove_folder = "<Leader>cwr",
                workspace_list_folders = "<Leader>cwl",
                workspace_symbols = "<Leader>ws",
            },
            diagnostics = {
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
            },
            servers = {
                stylua = { enabled = false },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                unusedLocalExclude = { "_*" }, -- Allow variables/arguments starting with '_' to be unused
                            },
                            workspace = {
                                checkThirdParty = false, -- Disable checking third-party libraries
                            },
                        },
                    },
                },
                ruby_lsp = {
                    mason = false, -- ruby lsp is installed via bundler or gem
                },
                rubocop = {
                    mason = false, -- rubocop is installed via bundler or gem
                },
                bashls = true,
                gopls = {
                    cmd = { "gopls", "-remote=auto" },
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                        },
                    },
                },
                jdtls = {
                    enabled = false, -- This lsp server needs to be manually enabled
                },
            },
            setup = {
                ruby_lsp = function(_, _)
                    require("gem_install").install("ruby-lsp")
                    return false -- Let the default setup handle the rest
                end,
                rubocop = function(_, _)
                    require("gem_install").install("rubocop")
                    return false -- Let the default setup handle the rest
                end,
            }, -- add custom setup functions for servers here
        },
        config = vim.schedule_wrap(function(_, opts)
            local servers = opts.servers
            local blink = require("blink.cmp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                blink.get_lsp_capabilities(),
                opts.capabilities or {}
            )

            -- Pass opts to the on_attach function to be able to customize keymaps
            Utils.lsp.setup_on_attach(function(client, buf)
                LspConfig.on_attach(client, buf, opts)
            end)
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local mason_all = vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
            local automatic_enable_exclude = {}

            -- We'll call this for each of our configured lsp servers
            local function configure(server)
                local server_opts = opts.servers[server]
                server_opts = server_opts == true and {} or (not server_opts) and { enabled = false } or server_opts
                server_opts = vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities) }, server_opts)

                -- if we don't want to install a server with mason, we can set mason = false in its opts
                local use_mason = server_opts.mason ~= false and vim.tbl_contains(mason_all, server)
                -- we can separately prevent a server from being automatically enabled while still installing it with mason
                if server_opts.enabled == false then
                    automatic_enable_exclude[#automatic_enable_exclude + 1] = server
                    return use_mason
                end

                -- in addition to installing our lsp server, we call any custom setup functions here
                local setup = opts.setup[server] or opts.setup["*"]
                if setup and setup(server, server_opts) then
                    -- we already called the setup function for this server, so prevent mason from calling it again
                    automatic_enable_exclude[#automatic_enable_exclude + 1] = server
                else
                    vim.lsp.config(server, server_opts)
                    -- if we're using mason to install the server, mason will also handle enabling it
                    -- if not, we enable it outside mason here
                    if not use_mason then
                        vim.lsp.enable(server)
                        automatic_enable_exclude[#automatic_enable_exclude + 1] = server
                    end
                end
                return use_mason
            end

            local ensure_installed = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))

            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed,
                automatic_enable = { exclude = automatic_enable_exclude },
            })
        end),
    },
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        dependencies = {
            {
                "cosmicbuffalo/mason-lock.nvim",
                opts = {
                    lockfile_scope = "locked_packages", -- only the three core packages below will be included in the lockfile
                    locked_packages = {
                        { "tree-sitter-cli", version = "v0.25.10" },
                        "stylua",
                        "shfmt",
                        "goimports",
                        "gofumpt",
                    },
                    silent = true,
                },
            },
        },
        keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
        },
        build = ":MasonUpdate",
        opts_extend = { "ensure_installed" },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local ml = require("mason-lock")

            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            mr.refresh(function()
                for _, tool in ipairs(ml.locked_packages()) do
                    local tool_name = type(tool) == "table" and tool[1] or tool
                    local p = mr.get_package(tool_name)
                    if not p:is_installed() and not p:is_installing() then
                        p:install()
                    end
                end
            end)
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "lazy.nvim", words = { "LazyVim" } },
            },
        },
    },
}
