-- Utility functions for related to working with Lazy.nvim
local M = {}

-- Required lazy.nvim version for compatibility
M.REQUIRED_LAZY_VERSION = "11.17.1"

M.LazyFileEvents = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.get_plugin(name)
    return require("lazy.core.config").spec.plugins[name]
end

function M.opts(name)
    local plugin = M.get_plugin(name)
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

function M.check_version()
    local ok, result = pcall(function()
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if vim.fn.isdirectory(lazypath) == 0 then
            vim.notify("lockfile manager: lazy.nvim directory not found at " .. lazypath, vim.log.levels.WARN)
            return false
        end

        local Git = require("lazy.manage.git")
        local git_info = Git.info(lazypath, true)
        if git_info and git_info.version then
            local installed_version = tostring(git_info.version)
            if installed_version ~= M.REQUIRED_LAZY_VERSION then
                vim.notify(string.format(
                    "lockfile manager: requires lazy.nvim == %s, but found %s. Some features may not work correctly.",
                    M.REQUIRED_LAZY_VERSION,
                    installed_version
                ), vim.log.levels.WARN)
                return false
            end
        else
            -- If we can't determine the version, check for required API functions
            local Config = require("lazy.core.config")
            local lock = require("lazy.manage.lock")

            if not Config.plugins or not Config.spec or not lock.update then
                vim.notify("lockfile manager: incompatible lazy.nvim version - missing required APIs", vim.log.levels.WARN)
                return false
            end

            vim.notify(
                "lockfile manager: Could not determine lazy.nvim version (requires == " .. M.REQUIRED_LAZY_VERSION .. ")",
                vim.log.levels.WARN
            )
        end
        return true
    end)

    if not ok then
        vim.notify("lockfile manager: Error checking lazy.nvim version: " .. tostring(result), vim.log.levels.WARN)
        return false
    end

    return result
end

local function get_config_repo_paths()
    local config_dir = vim.fn.stdpath("config")
    local personal_dir = config_dir .. "/lua/personal"

    -- Resolve symlinks to get the real paths
    local shared_real_path = vim.fn.resolve(config_dir)
    local personal_real_path = vim.fn.resolve(personal_dir)

    return shared_real_path, personal_real_path
end

local function plugin_exists_in_repo(plugin_name, repo_path)
    local escaped_plugin = plugin_name:gsub("([%-%.%+%[%]%(%)%$%^%%%?%*])", "%%%1")

    -- Search both direct plugins/ folders and nested plugins/ folders
    local files1 = vim.fn.glob(repo_path .. "/plugins/**/*.lua", true, true)
    local files2 = vim.fn.glob(repo_path .. "/**/plugins/**/*.lua", true, true)

    local files = {}
    for _, file in ipairs(files1) do
        table.insert(files, file)
    end
    for _, file in ipairs(files2) do
        table.insert(files, file)
    end

    -- If we're searching the shared repo, exclude files that are in the personal repo
    local shared_path, personal_path = get_config_repo_paths()
    if repo_path == shared_path then
        local filtered_files = {}
        for _, file in ipairs(files) do
            -- Check for literal "/lua/personal/" in the file path, not the resolved symlink
            if not file:find("/lua/personal/", 1, true) then
                table.insert(filtered_files, file)
            end
        end
        files = filtered_files
    end

    for _, file in ipairs(files) do
        local content = vim.fn.readfile(file)
        local file_content = table.concat(content, "\n")

        -- First try: "username/repo-name" format
        local pattern1 = '["\'][^/"]+/' .. escaped_plugin .. "[\"']"
        if file_content:find(pattern1) then
            return true
        end

        -- Second try: name attribute assignment (for plugins with custom 'name' property)
        local pattern2 = 'name%s*=%s*["\']' .. escaped_plugin .. '["\']'
        if file_content:find(pattern2) then
            return true
        end
    end

    return false
end

function M.get_plugin_source(plugin_name)
    local shared_path, personal_path = get_config_repo_paths()

    if plugin_name == "lazy.nvim" then
        return shared_path
    end

    if plugin_exists_in_repo(plugin_name, shared_path) then
        return shared_path
    end

    if plugin_exists_in_repo(plugin_name, personal_path) then
        return personal_path
    end

    local debug_msg = string.format("Plugin '%s' not found in shared or personal configuration files.\n", plugin_name)
    error(debug_msg)
end

function M.read_lockfile(path)
    if vim.fn.filereadable(path) == 0 then
        return {}
    end

    local content = vim.fn.readfile(path)
    local json_str = table.concat(content, "\n")

    local ok, decoded = pcall(vim.json.decode, json_str)
    if not ok then
        return {}
    end

    return decoded
end

local function write_lockfile(path, data)
    local dir = vim.fn.fnamemodify(path, ":h")
    vim.fn.mkdir(dir, "p")

    -- Format lockfile exactly like lazy.nvim does (with pretty indentation)
    local f = assert(io.open(path, "wb"))
    f:write("{\n")

    local names = vim.tbl_keys(data)
    table.sort(names)

    for n, name in ipairs(names) do
        local info = data[name]
        f:write(([[  %q: { "branch": %q, "commit": %q }]]):format(name, info.branch, info.commit))
        if n ~= #names then
            f:write(",\n")
        end
    end
    f:write("\n}\n")
    f:close()
end

function M.setup_lazy_hooks()
    local ok, err = pcall(function()
        -- Notify on mismatched version but continue assuming lazy hasn't changed to be incompatible
        M.check_version()

        local lock = require("lazy.manage.lock")
        local original_update = lock.update

        -- Override lazy's lockfile update function with error handling
        lock.update = function()
            local original_ok, original_err = pcall(original_update)
            if not original_ok then
                vim.notify("lockfile manager: Error in original lazy update: " .. tostring(original_err), vim.log.levels.ERROR)
                return -- Don't try our custom logic if original failed
            end

            local lockfile_ok, lockfile_err = pcall(M.write_dual_lockfiles)
            if not lockfile_ok then
                vim.notify("lockfile manager: Error managing dual lockfiles: " .. tostring(lockfile_err), vim.log.levels.ERROR)
            end
        end

        -- Also hook into the lazy TUI to show shared/personal status (with error handling)
        local ui_ok, ui_err = pcall(M.setup_ui_hooks)
        if not ui_ok then
            vim.notify("lockfile manager: Error setting up UI hooks: " .. tostring(ui_err), vim.log.levels.WARN)
            -- Continue silently - original lazy UI behavior is preserved
        end
    end)

    if not ok then
        vim.notify("lockfile manager: Failed to setup hooks: " .. tostring(err), vim.log.levels.ERROR)
        vim.notify("lockfile manager: Falling back to default lazy.nvim behavior", vim.log.levels.WARN)
    end
end

function M.setup_ui_hooks()
    local ok, err = pcall(function()
        local render = require("lazy.view.render")
        local original_details = render.details

        render.details = function(self, plugin)
            -- Wrap our custom logic in error handling, fall back to original if it fails
            local custom_ok, custom_err = pcall(function()
                -- Build props array like the original function does
                local props = {}

                -- Add our source information at the top
                local source = "unknown"
                local source_ok, result = pcall(M.get_plugin_source, plugin.name)
                if source_ok then
                    source = result
                end

                -- Put in all the same properties as the original details function
                table.insert(props, { "source", source, "LazyReasonEvent" })
                table.insert(props, { "dir", plugin.dir, "LazyDir" })
                if plugin.url then
                    table.insert(props, { "url", (plugin.url:gsub("%.git$", "")), "LazyUrl" })
                end

                local Git = require("lazy.manage.git")
                local Util = require("lazy.util")
                local git = Git.info(plugin.dir, true)
                if git then
                    git.branch = git.branch or Git.get_branch(plugin)
                    if git.version then
                        table.insert(props, { "version", tostring(git.version) })
                    end
                    if git.tag then
                        table.insert(props, { "tag", git.tag })
                    end
                    if git.branch then
                        table.insert(props, { "branch", git.branch })
                    end
                    if git.commit then
                        table.insert(props, { "commit", git.commit:sub(1, 7), "LazyCommit" })
                    end
                end

                local rocks = require("lazy.pkg.rockspec").deps(plugin)
                if rocks then
                    table.insert(props, { "rocks", vim.inspect(rocks) })
                end

                if Util.file_exists(plugin.dir .. "/README.md") then
                    table.insert(props, { "readme", "README.md" })
                end
                Util.ls(plugin.dir .. "/doc", function(path, name)
                    if name:sub(-3) == "txt" then
                        local data = Util.read_file(path)
                        local tag = data:match("%*(%S-)%*")
                        if tag then
                            table.insert(props, { "help", "|" .. tag .. "|" })
                        end
                    end
                end)

                for handler in pairs(plugin._.handlers or {}) do
                    table.insert(props, {
                        handler,
                        function()
                            self:handlers(plugin, handler)
                        end,
                    })
                end

                self:props(props, { indent = 6 })
                self:nl()
            end)

            if not custom_ok then
                -- Fall back to original details function if our custom logic fails
                vim.notify("lockfile manager: Error in UI details hook: " .. tostring(custom_err), vim.log.levels.WARN)
                original_details(self, plugin)
            end
        end
    end)

    if not ok then
        vim.notify("lockfile manager: Failed to setup UI hooks: " .. tostring(err), vim.log.levels.WARN)
    end
end

function M.write_dual_lockfiles()
    local Config = require("lazy.core.config")
    local Git = require("lazy.manage.git")
    local main_lockfile = Config.options.lockfile
    local existing_lockfile = M.read_lockfile(main_lockfile)

    local plugins_by_source = {}

    local all_plugins = {}

    -- Add enabled/loaded plugins
    for _, plugin in pairs(Config.plugins) do
        all_plugins[plugin.name] = plugin
    end

    -- Add disabled plugins
    for _, plugin in pairs(Config.spec.disabled) do
        all_plugins[plugin.name] = plugin
    end

    -- Add all spec plugins (includes lazy-loaded plugins like ft-specific ones)
    for _, plugin in pairs(Config.spec.plugins) do
        if plugin.name and not all_plugins[plugin.name] then
            all_plugins[plugin.name] = plugin
        end
    end

    for _, plugin in pairs(all_plugins) do
        if not plugin._.is_local then
            local source_repo = M.get_plugin_source(plugin.name)
            local lockfile_entry = nil

            if plugin._.installed then
                local info = Git.info(plugin.dir)
                if info then
                    lockfile_entry = {
                        branch = info.branch or Git.get_branch(plugin),
                        commit = info.commit,
                    }
                end
            else
                -- For disabled plugins, use existing lockfile entry if available
                lockfile_entry = existing_lockfile[plugin.name]
            end

            if lockfile_entry then
                if not plugins_by_source[source_repo] then
                    plugins_by_source[source_repo] = {}
                end

                plugins_by_source[source_repo][plugin.name] = lockfile_entry
            end
        end
    end

    -- Write lockfiles to each source repository's root directory
    for source_repo, plugins in pairs(plugins_by_source) do
        local lockfile_path = source_repo .. "/lazy-lock.json"
        write_lockfile(lockfile_path, plugins)
    end
end

return M
