-- LSP: configure the Language Server Protocol (LSP) client.
local Utils = require("config.utils")
local LazyFileEvents = Utils.lazy.LazyFileEvents
local LspConfig = require("config.lsp")

-- cache file stores bundle install failure history by cwd
local cache_file = vim.fn.stdpath("cache") .. "/bundle_install_cache.json"
-- log file holds all bundle/gem install output
local log_file = vim.fn.stdpath("log") .. "/bundle_gem_debug.log"
vim.api.nvim_create_user_command("BundleInstallLog", function()
    vim.cmd("edit " .. log_file)
end, { desc = "Open bundle/gem debug log" })
vim.api.nvim_create_user_command("BundleInstallCache", function()
    vim.cmd("edit " .. cache_file)
end, { desc = "Open bundle/gem install cache file" })
vim.api.nvim_create_user_command("BundleInstallCacheClear", function()
    if vim.fn.filereadable(cache_file) == 1 then
        vim.fn.delete(cache_file)
        vim.notify(
            "Bundle/gem install cache cleared. Failed projects will be retried on next open.",
            vim.log.levels.INFO
        )
    else
        vim.notify("No bundle/gem install cache found.", vim.log.levels.INFO)
    end
end, { desc = "Clear bundle install failure cache" })
vim.api.nvim_create_user_command("BundleInstallLogClear", function()
    if vim.fn.filereadable(log_file) == 1 then
        vim.fn.delete(log_file)
        vim.notify("Bundle/gem debug log cleared.", vim.log.levels.INFO)
    else
        vim.notify("No bundle/gem debug log found.", vim.log.levels.INFO)
    end
end, { desc = "Clear bundle/gem install debug log" })

local function load_cache()
    local file = io.open(cache_file, "r")
    if not file then
        return {}
    end
    local content = file:read("*a")
    file:close()
    local success, cache = pcall(vim.json.decode, content)
    return success and cache or {}
end

local function save_cache(cache)
    local file = io.open(cache_file, "w")
    if file then
        file:write(vim.json.encode(cache))
        file:close()
    end
end

local function debug_log(msg)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local log_line = string.format("[%s] %s\n", timestamp, msg)

    vim.schedule(function()
        local file = io.open(log_file, "a")
        if file then
            file:write(log_line)
            file:close()
        end
    end)
end

local function install_gem(gem_name)
    local gemfile = vim.fn.findfile("Gemfile", ".;")
    if gemfile == "" then
        return
    end

    local cwd = vim.fn.fnamemodify(gemfile, ":h")

    local cache = load_cache()
    if cache[cwd] and cache[cwd].failed then
        debug_log(
            string.format(
                "Skipping bundle install for %s (previously failed). Remove cache to retry: rm %s",
                gem_name,
                cache_file
            )
        )
        return
    end

    local progress = require("fidget.progress")
    local handle = progress.handle.create({
        title = gem_name,
        message = "checking bundle...",
        lsp_client = { name = gem_name },
    })

    local function run_gem_install()
        handle.message = "gem install " .. gem_name .. "..."
        local gem_output = {}
        vim.fn.jobstart("gem install " .. gem_name, {
            cwd = cwd,
            stdout_buffered = true,
            stderr_buffered = true,
            on_stdout = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        if line ~= "" then
                            table.insert(gem_output, line)
                            handle.message = line
                        end
                    end
                end
            end,
            on_stderr = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        if line ~= "" then
                            table.insert(gem_output, line)
                            handle.message = line
                        end
                    end
                end
            end,
            on_exit = function(_, gem_exit_code)
                if gem_exit_code == 0 then
                    handle:finish()
                    cache[cwd] = { failed = false }
                    save_cache(cache)
                    if #gem_output > 0 then
                        debug_log(
                            string.format("gem install %s succeeded:\n%s", gem_name, table.concat(gem_output, "\n"))
                        )
                    end
                else
                    local message = string.format("gem install %s failed. Run manually if needed.", gem_name)
                    handle.message = message
                    handle:cancel()
                    if #gem_output > 0 then
                        message = message .. "\n" .. table.concat(gem_output, "\n")
                    end
                    cache[cwd] = { failed = true, reason = "gem_install_failed", gem = gem_name }
                    save_cache(cache)
                    debug_log(message)
                end
            end,
        })
    end

    local function check_and_install_gem()
        handle.message = "checking gem " .. gem_name .. "..."
        vim.fn.jobstart("gem list -i '^" .. gem_name .. "$'", {
            cwd = cwd,
            on_exit = function(_, gem_list_exit_code)
                if gem_list_exit_code == 0 then
                    -- Gem is already installed, we're done
                    handle.message = "already installed"
                    handle:finish()
                    cache[cwd] = { failed = false }
                    save_cache(cache)
                else
                    run_gem_install()
                end
            end,
        })
    end

    vim.fn.jobstart("bundle check", {
        cwd = cwd,
        on_exit = function(_, check_exit_code)
            if check_exit_code == 0 then
                check_and_install_gem()
                return
            end

            handle.message = "bundle install..."
            local output = {}
            local bundle_job_id
            local timeout_ms = 60000
            local timed_out = false

            local timer = vim.defer_fn(function()
                if bundle_job_id then
                    timed_out = true
                    vim.fn.jobstop(bundle_job_id)
                end
            end, timeout_ms)

            bundle_job_id = vim.fn.jobstart("bundle install", {
                cwd = cwd,
                stdout_buffered = true,
                stderr_buffered = true,
                on_stdout = function(_, data)
                    if data then
                        for _, line in ipairs(data) do
                            if line ~= "" then
                                table.insert(output, line)
                                handle.message = line
                            end
                        end
                    end
                end,
                on_stderr = function(_, data)
                    if data then
                        for _, line in ipairs(data) do
                            if line ~= "" then
                                table.insert(output, line)
                                handle.message = line
                            end
                        end
                    end
                end,
                on_exit = function(_, exit_code)
                    if timer then
                        pcall(function()
                            timer:stop()
                        end)
                    end

                    if timed_out then
                        local message = string.format(
                            "bundle install timed out after %ds. Skipping %s setup.",
                            timeout_ms / 1000,
                            gem_name
                        )
                        handle.message = message
                        handle:cancel()
                        cache[cwd] = { failed = true, reason = "timeout" }
                        save_cache(cache)
                        if #output > 0 then
                            message = message .. "\nOutput:\n" .. table.concat(output, "\n")
                        end
                        debug_log(message)
                        return
                    end

                    if exit_code == 0 then
                        if #output > 0 then
                            debug_log(string.format("bundle install succeeded:\n%s", table.concat(output, "\n")))
                        end
                        check_and_install_gem()
                    else
                        handle.message = "bundle install failed"
                        handle:cancel()
                        cache[cwd] = { failed = true, reason = "bundle_install_failed" }
                        save_cache(cache)
                        local message = string.format(
                            "bundle install failed. Skipping %s setup. Run 'bundle install' manually if needed, it will not be attempted again automatically.",
                            gem_name
                        )
                        if #output > 0 then
                            message = message .. "\n" .. table.concat(output, "\n")
                        end
                        debug_log(message)
                    end
                end,
            })
        end,
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        event = LazyFileEvents,
        dependencies = {
            "mason.nvim",
            { "mason-org/mason-lspconfig.nvim", config = function() end },
            {
                "j-hui/fidget.nvim",
                opts = {
                    notification = {
                        window = {
                            winblend = 0, -- transparent background
                        },
                    },
                },
            },
            "saghen/blink.cmp",
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
                jdtls = {
                    enabled = false, -- This lsp server needs to be manually enabled
                },
            },
            setup = {
                ruby_lsp = function(_, _)
                    install_gem("ruby-lsp")
                    return false -- Let the default setup handle the rest
                end,
                rubocop = function(_, _)
                    install_gem("rubocop")
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
                    lockfile_scope = "ensure_installed", -- only the three core packages below will be included in the lockfile
                    ensure_installed = {
                        { "tree-sitter-cli", version = "v0.25.10" },
                        "stylua",
                        "shfmt",
                    },
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
                for _, tool in ipairs(ml.ensure_installed()) do
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
