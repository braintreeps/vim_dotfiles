local Utils = require("config.utils")
local M = {}

-- Configuration
local config = {
    -- Path to the dotfiles repository (default: current Neovim config directory)
    repo_path = vim.fn.stdpath("config"),
    -- Title for the updater window
    title = "Neovim Dotfiles Updater",
    -- How many commits to show in the log
    log_count = 15,
    -- Main branch name
    main_branch = "main",
    -- Notification settings
    notify = {
        up_to_date = {
            title = "Neovim Dotfiles",
            message = "Your dotfiles are up to date!",
            level = "info",
        },
        outdated = {
            title = "Neovim Dotfiles",
            message = "Updates available! Press <leader>e to open the updater.",
            level = "warn",
        },
        error = {
            title = "Neovim Dotfiles",
            message = "Error checking for updates",
            level = "error",
        },
        updated = {
            title = "Neovim Dotfiles",
            message = "Successfully updated dotfiles!",
            level = "info",
        },
    },
    keys = {
        open = "<leader>e", -- Key to open the updater
        update = "u",      -- Key to trigger update
        refresh = "r",     -- Key to refresh status
        close = "q",       -- Key to close the updater
        install_plugins = "i", -- Key to install plugin updates via lazy restore
        update_all = "U",  -- Key to update dotfiles and auto-run lazy restore
    }
}

-- State
local state = {
    is_open = false,
    buffer = nil,
    window = nil,
    commits = {},
    current_commit = nil,
    is_updating = false,
    needs_update = false,
    current_branch = "",
    ahead_count = 0,
    behind_count = 0,
    plugin_updates = {},
    has_plugin_updates = false,
    is_installing_plugins = false,
}

local cd_repo_path = "cd " .. config.repo_path .. " && "

-- Utility functions
local function execute_command(cmd)
    local handle = io.popen(cmd .. " 2>&1")
    if not handle then
        return nil, "Failed to execute command"
    end

    local result = handle:read("*a")
    handle:close()
    return result, nil
end

local function get_current_commit()
    local result, err = execute_command(cd_repo_path .. "git rev-parse HEAD")
    if err or not result then
        return nil
    end
    return vim.trim(result)
end

local function get_remote_commit()
    -- Fetch from remote without merging
    local _, err = execute_command(cd_repo_path .. "git fetch")
    if err then
        return nil
    end

    local result, fetch_err = execute_command(cd_repo_path .. "git rev-parse @{u}")
    if fetch_err or not result then
        return nil
    end
    return vim.trim(result)
end

local function get_current_branch()
    local result, err = execute_command(cd_repo_path .. "git rev-parse --abbrev-ref HEAD")
    if err or not result then
        return "unknown"
    end
    return vim.trim(result)
end

local function get_ahead_behind_count()
    local branch = get_current_branch()
    local main = config.main_branch

    -- If we're on main, compare with origin/main
    local compare_with = "origin/" .. main

    local result, err = execute_command(
        cd_repo_path .. "git rev-list --left-right --count " .. branch .. "..." .. compare_with
    )

    if err or not result then
        return 0, 0
    end
    local ahead, behind = result:match("(%d+)%s+(%d+)")
    return tonumber(ahead) or 0, tonumber(behind) or 0
end

local function get_latest_remote_commit()
    local cmd = cd_repo_path .. "git fetch && git rev-parse origin/" .. config.main_branch

    local result, err = execute_command(cmd)
    if err or not result then
        return nil
    end

    local hash = vim.trim(result)

    -- Get commit details with a simpler format to avoid parsing issues
    local details_cmd = "cd " .. config.repo_path .. ' && git show -s --format="%h|%s|%an|%ar" ' .. hash

    local details, details_err = execute_command(details_cmd)
    if details_err or not details then
        return nil
    end

    -- Parse the details, being careful with the message part
    local parts = vim.split(details, "|", { plain = true })
    if #parts < 4 then
        return nil
    end

    local short_hash = vim.trim(parts[1] or "")
    local message = vim.trim(parts[2] or "")
    local author = vim.trim(parts[3] or "")
    local date = vim.trim(parts[4] or "")

    -- Truncate message to first 80 chars and remove any newlines
    message = message:gsub("\r", ""):gsub("\n.*", "")
    if #message > 80 then
        message = message:sub(1, 77) .. "..."
    end

    if short_hash ~= "" then
        return {
            hash = short_hash,
            message = message,
            author = author,
            date = date,
            full_hash = hash,
        }
    end

    return nil
end

local function is_commit_in_branch(commit_hash, branch)
    local cmd = cd_repo_path
        .. "git branch --contains "
        .. commit_hash
        .. " | grep -q "
        .. branch
        .. " && echo yes || echo no"

    local result, err = execute_command(cmd)
    if err or not result then
        return false
    end

    return vim.trim(result) == "yes"
end

local function get_commit_log()
    local branch = get_current_branch()
    local main = config.main_branch
    local cmd
    local log_type = ""

    -- If we're on main, show commits between HEAD and origin/main
    if branch == main then
        if state.behind_count > 0 then
            cmd = "cd "
                .. config.repo_path
                .. " && git log -n "
                .. config.log_count
                .. ' --format=format:"%h|%s|%an|%ar" origin/'
                .. main
                .. " ^HEAD"
            log_type = "remote"
        else
            cmd = "cd "
                .. config.repo_path
                .. " && git log -n "
                .. config.log_count
                .. ' --format=format:"%h|%s|%an|%ar" HEAD'
            log_type = "local"
        end
    else
        -- If ahead of main, show commits that are in current branch but not in main
        if state.ahead_count > 0 then
            cmd = "cd "
                .. config.repo_path
                .. " && git log -n "
                .. config.log_count
                .. ' --format=format:"%h|%s|%an|%ar" '
                .. branch
                .. " ^"
                .. main
            log_type = "local"
        else
            -- If behind main, show commits that are in main but not in current branch
            cmd = "cd "
                .. config.repo_path
                .. " && git log -n "
                .. config.log_count
                .. ' --format=format:"%h|%s|%an|%ar" '
                .. main
                .. " ^"
                .. branch
            log_type = "remote"
        end
    end

    local result, err = execute_command(cmd)
    if err or not result then
        return {}, log_type
    end

    local commits = {}
    for line in result:gmatch("[^\r\n]+") do
        -- Parse the line by splitting on | instead of using pattern matching
        local parts = vim.split(line, "|", { plain = true })
        if #parts >= 4 then
            local hash = vim.trim(parts[1] or "")
            local message = vim.trim(parts[2] or "")
            local author = vim.trim(parts[3] or "")
            local date = vim.trim(parts[4] or "")

            -- Truncate message to first 80 chars and remove any newlines
            message = message:gsub("\r", ""):gsub("\n.*", "")
            if #message > 80 then
                message = message:sub(1, 77) .. "..."
            end

            if hash ~= "" then
                table.insert(commits, {
                    hash = hash,
                    message = message,
                    author = author,
                    date = date,
                })
            end
        end
    end
    return commits, log_type
end

-- Get remote commits that are not in the local branch
local function get_remote_commits_not_in_local()
    local branch = get_current_branch()
    local main = config.main_branch
    local compare_with = "origin/" .. main

    -- Get commits that are in remote but not in local
    local cmd = cd_repo_path
        .. "git log -n "
        .. config.log_count
        .. ' --format=format:"%h|%s|%an|%ar" '
        .. compare_with
        .. " ^"
        .. branch

    local result, err = execute_command(cmd)
    if err or not result then
        return {}
    end

    local commits = {}
    for line in result:gmatch("[^\r\n]+") do
        local parts = vim.split(line, "|", { plain = true })
        if #parts >= 4 then
            local hash = vim.trim(parts[1] or "")
            local message = vim.trim(parts[2] or "")
            local author = vim.trim(parts[3] or "")
            local date = vim.trim(parts[4] or "")

            -- Truncate message to first 80 chars and remove any newlines
            message = message:gsub("\r", ""):gsub("\n.*", "")
            if #message > 80 then
                message = message:sub(1, 77) .. "..."
            end

            if hash ~= "" then
                table.insert(commits, {
                    hash = hash,
                    message = message,
                    author = author,
                    date = date,
                })
            end
        end
    end
    return commits
end

local function get_installed_plugin_commit(plugin_name)
    local lazy_config = require("lazy.core.config")
    local plugin = lazy_config.plugins[plugin_name]

    if not plugin or not plugin._.installed then
        return nil
    end

    local Git = require("lazy.manage.git")
    local info = Git.info(plugin.dir)

    if info then
        return info.commit
    end

    return nil
end

local function get_plugin_updates()
    local plugin_updates = {}
    local lockfile_path = config.repo_path .. "/lazy-lock.json"
    local lockfile_data = Utils.lazy.read_lockfile(lockfile_path)

    for plugin_name, lock_info in pairs(lockfile_data) do
        local installed_commit = get_installed_plugin_commit(plugin_name)

        if installed_commit and lock_info.commit then
            if installed_commit ~= lock_info.commit then
                table.insert(plugin_updates, {
                    name = plugin_name,
                    installed_commit = installed_commit:sub(1, 7),
                    lockfile_commit = lock_info.commit:sub(1, 7),
                    branch = lock_info.branch or "main",
                })
            end
        end
    end

    return plugin_updates
end

local function install_plugin_updates()
    state.is_installing_plugins = true
    M.render()

    local cmd = cd_repo_path .. "nvim --headless +'lua require(\"lazy\").restore({wait=true})' +qa"
    local result, err = execute_command(cmd)

    state.is_installing_plugins = false

    if err or not result or result:match("error") or result:match("Error") then
        vim.notify(
            "Failed to install plugin updates: " .. (result or err or "Unknown error"),
            vim.log.levels.ERROR,
            { title = "Plugin Updates" }
        )
    else
        vim.notify(
            "Successfully restored plugins from lockfile!",
            vim.log.levels.INFO,
            { title = "Plugin Updates" }
        )
        -- Refresh plugin update status
        state.plugin_updates = get_plugin_updates()
        state.has_plugin_updates = #state.plugin_updates > 0
    end

    M.render()
end

local function update_dotfiles_and_plugins()
    state.is_updating = true
    M.render()

    -- First update dotfiles
    M.update_repo()

    -- Then install plugin updates if the dotfiles update was successful
    if not state.is_updating then -- update_repo sets this to false when done
        install_plugin_updates()
    end
end

-- Check if commits exist in the current branch
local function are_commits_in_branch(commits, branch)
    local result = {}
    for _, commit in ipairs(commits) do
        result[commit.hash] = is_commit_in_branch(commit.hash, branch)
    end
    return result
end

local function get_repo_status()
    -- Fetch from remote without merging
    local _, fetch_err = execute_command(cd_repo_path .. "git fetch")
    if fetch_err then
        return { error = true }
    end

    -- Get current branch
    local branch = get_current_branch()

    -- Get ahead/behind counts
    local ahead, behind = get_ahead_behind_count()

    return {
        branch = branch,
        ahead = ahead,
        behind = behind,
        is_main = branch == config.main_branch,
        error = false,
        up_to_date = behind == 0,
        has_local_changes = ahead > 0,
    }
end

function M.update_repo()
    state.is_updating = true
    M.render()

    -- Get current branch
    local branch = get_current_branch()
    local cmd = ""

    -- Always fetch first to get latest changes
    local fetch_result, fetch_err =
        execute_command(cd_repo_path .. "git fetch origin " .. config.main_branch)
    if fetch_err then
        state.is_updating = false
        vim.notify(
            "Failed to fetch updates: " .. (fetch_result or fetch_err or "Unknown error"),
            vim.log.levels.ERROR,
            { title = config.notify.error.title }
        )
        M.refresh()
        return
    end

    -- Different update strategy based on current branch
    if branch == config.main_branch then
        -- If on main branch, just pull from origin/main
        cmd = "git pull origin " .. config.main_branch
    else
        -- If on a different branch, merge origin/main into current branch
        cmd = "git merge origin/" .. config.main_branch .. " --no-edit"
    end

    -- Execute the update command
    local result, err = execute_command(cd_repo_path .. cmd)

    state.is_updating = false

    if err or not result or result:match("error") or result:match("Error") or result:match("conflict") then
        vim.notify(
            "Failed to update: " .. (result or err or "Unknown error"),
            vim.log.levels.ERROR,
            { title = config.notify.error.title }
        )
    else
        -- Check if anything was updated
        if result:match("Already up to date") then
            vim.notify(
                "Already up to date with origin/" .. config.main_branch,
                vim.log.levels.INFO,
                { title = config.notify.updated.title }
            )
        else
            if branch == config.main_branch then
                vim.notify(
                    "Successfully pulled changes from origin/" .. config.main_branch,
                    vim.log.levels.INFO,
                    { title = config.notify.updated.title }
                )
            else
                vim.notify(
                    "Successfully merged origin/" .. config.main_branch .. " into " .. branch,
                    vim.log.levels.INFO,
                    { title = config.notify.updated.title }
                )
            end
        end
        state.needs_update = false
    end

    -- Refresh the UI to show the updated status
    M.refresh()
end

-- UI functions
function M.create_window()
    -- Calculate dimensions (similar to Lazy TUI)
    local width = math.min(math.floor(vim.o.columns * 0.9), 150)
    local height = math.min(math.floor(vim.o.lines * 0.8), 40)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create buffer
    state.buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(state.buffer, "bufhidden", "wipe")

    -- Set buffer options
    local buf_opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
        title = config.title,
        title_pos = "center",
    }

    -- Create window
    state.window = vim.api.nvim_open_win(state.buffer, true, buf_opts)

    -- Set window options
    vim.api.nvim_win_set_option(state.window, "winblend", 10)
    vim.api.nvim_win_set_option(state.window, "cursorline", true)

    -- Set buffer keymaps
    local opts = { buffer = state.buffer, noremap = true, silent = true }
    vim.keymap.set("n", config.keys.close, M.close, opts)
    vim.keymap.set("n", "<Esc>", M.close, opts)
    vim.keymap.set("n", config.keys.update, M.update_repo, opts)
    vim.keymap.set("n", config.keys.refresh, M.refresh, opts)
    vim.keymap.set("n", config.keys.install_plugins, install_plugin_updates, opts)
    vim.keymap.set("n", config.keys.update_all, update_dotfiles_and_plugins, opts)

    -- Set buffer as non-modifiable
    vim.api.nvim_buf_set_option(state.buffer, "modifiable", false)

    -- Set buffer filetype for potential syntax highlighting
    vim.api.nvim_buf_set_option(state.buffer, "filetype", "dotfiles-updater")

    -- Create autocommand to close the window when leaving the buffer
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = state.buffer,
        callback = function()
            M.close()
        end,
        once = true,
    })

    state.is_open = true
end

function M.render()
    if not state.buffer or not state.is_open then
        return
    end

    -- Make buffer modifiable
    vim.api.nvim_buf_set_option(state.buffer, "modifiable", true)

    -- Clear buffer
    vim.api.nvim_buf_set_lines(state.buffer, 0, -1, false, {})

    -- Add header
    local header = {
        "",
    }

    -- Branch information
    local branch_info = "  Branch: " .. state.current_branch
    table.insert(header, branch_info)

    -- Add ahead/behind information
    if state.current_branch == config.main_branch then
        if state.ahead_count > 0 then
            table.insert(
                header,
                string.format(
                    "  Your %s branch is ahead of origin/%s by %d commits",
                    config.main_branch,
                    config.main_branch,
                    state.ahead_count
                )
            )
        elseif state.behind_count > 0 then
            table.insert(
                header,
                string.format(
                    "  Your %s branch is behind origin/%s by %d commits",
                    config.main_branch,
                    config.main_branch,
                    state.behind_count
                )
            )
        else
            table.insert(
                header,
                string.format("  Your %s branch is in sync with origin/%s", config.main_branch, config.main_branch)
            )
        end
    else
        if state.ahead_count > 0 then
            table.insert(
                header,
                string.format(
                    "  Your branch is ahead of origin/%s by %d commits",
                    config.main_branch,
                    state.ahead_count
                )
            )
        end
        if state.behind_count > 0 then
            table.insert(
                header,
                string.format("  Your branch is behind origin/%s by %d commits", config.main_branch, state.behind_count)
            )
        end
    end
    table.insert(header, "")

    if state.is_updating then
        table.insert(header, "  Updating dotfiles... Please wait.")
        table.insert(header, "")
    elseif state.is_installing_plugins then
        table.insert(header, "  Installing plugin updates... Please wait.")
        table.insert(header, "")
    elseif state.behind_count > 0 or state.has_plugin_updates then
        local messages = {}
        if state.behind_count > 0 then
            table.insert(messages, "Dotfiles update")
        end
        if state.has_plugin_updates then
            table.insert(messages, tostring(#state.plugin_updates) .. " plugin updates")
        end
        table.insert(header, "  " .. table.concat(messages, " and ") .. " available!")
        table.insert(header, "")
    else
        table.insert(header, "  Your dotfiles and plugins are up to date!")
        table.insert(header, "")
    end

    -- Add keybindings help
    local keybindings = {
        "  Keybindings:",
        "    " .. config.keys.update_all .. " - Update dotfiles + install plugin updates",
        "    " .. config.keys.update .." - Update dotfiles",
        "    " .. config.keys.install_plugins .. " - Install plugin updates (:Lazy restore)",
        "    " .. config.keys.refresh .. " - Refresh status",
        "    " .. config.keys.close .. " - Close window",
        "",
    }

    -- Add remote commits info
    local remote_commit_info = {}
    if #state.remote_commits > 0 then
        table.insert(remote_commit_info, "  Commits on origin/" .. config.main_branch .. " not in your branch:")
        table.insert(remote_commit_info, "  " .. string.rep("─", 70))

        for _, commit in ipairs(state.remote_commits) do
            local status_indicator = state.commits_in_branch[commit.hash] and "✓" or "✗"

            -- All fields should already be sanitized, but let's be extra careful
            local hash = commit.hash or ""
            local message = commit.message or ""
            local author = commit.author or ""
            local date = commit.date or ""

            -- Create the line
            -- All fields should already be sanitized, but let's be extra careful
            local hash = commit.hash or ""
            local message = commit.message or ""
            local author = commit.author or ""
            local date = commit.date or ""

            -- Create the line
            local line = "  "
                .. status_indicator
                .. " "
                .. hash
                .. " - "
                .. message
                .. " ("
                .. author
                .. ", "
                .. date
                .. ")"

            table.insert(remote_commit_info, line)
        end
        table.insert(remote_commit_info, "  ")
    end

    -- Add plugin updates info
    local plugin_update_info = {}
    if #state.plugin_updates > 0 then
        table.insert(plugin_update_info, "  Plugin updates available:")
        table.insert(plugin_update_info, "  " .. string.rep("─", 70))

        for _, plugin in ipairs(state.plugin_updates) do
            local line = "  "
                .. plugin.name
                .. " ("
                .. plugin.installed_commit
                .. " → "
                .. plugin.lockfile_commit
                .. ")"

            table.insert(plugin_update_info, line)
        end
        table.insert(plugin_update_info, "  ")
    end

    -- Add commit log header
    local log_title = state.log_type == "remote"
            and "  Commits from origin/" .. config.main_branch .. " not in your branch:"
        or "  Local commits on " .. state.current_branch .. ":"

    local log_header = {
        log_title,
        "  " .. string.rep("─", 70),
    }

    -- Combine all sections
    local lines = {}

    -- Add header
    for _, line in ipairs(header) do
        table.insert(lines, line)
    end
    local status_line = #lines - 2

    local keybindings_start = #lines + 1
    -- Add keybindings
    for _, line in ipairs(keybindings) do
        table.insert(lines, line)
    end

    local remote_commit_line = #lines + 1
    -- Add remote commit info
    for _, line in ipairs(remote_commit_info) do
        table.insert(lines, line)
    end
    if #remote_commit_info == 0 then
        remote_commit_line = #lines - 1
    end

    local plugin_update_line = #lines + 1
    -- Add plugin update info
    for _, line in ipairs(plugin_update_info) do
        table.insert(lines, line)
    end
    if #plugin_update_info == 0 then
        plugin_update_line = #lines - 1
    end

    -- Add log header
    for _, line in ipairs(log_header) do
        table.insert(lines, line)
    end

    -- Add commit log
    local current_hash = state.current_commit
    for _, commit in ipairs(state.commits) do
        local prefix = "  "
        local indicator = "  "

        -- Mark current commit
        if commit.hash == current_hash:sub(1, #commit.hash) then
            indicator = "→ "
        end

        -- All fields should already be sanitized, but let's be extra careful
        local hash = commit.hash or ""
        local message = commit.message or ""
        local author = commit.author or ""
        local date = commit.date or ""

        -- Create the line directly without string.format
        local line = prefix .. indicator .. hash .. " - " .. message .. " (" .. author .. ", " .. date .. ")"

        table.insert(lines, line)
    end

    -- Set lines in buffer directly
    vim.api.nvim_buf_set_lines(state.buffer, 0, -1, false, lines)

    -- Add highlighting
    local ns_id = vim.api.nvim_create_namespace("DotfilesUpdater")
    vim.api.nvim_buf_clear_namespace(state.buffer, ns_id, 0, -1)

    -- Highlight branch info
    vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Directory", 1, 2, -1)

    -- Highlight ahead/behind info
    -- if state.ahead_count > 0 then
    --     vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "DiffAdd", 2, 2, -1)
    -- elseif state.behind_count > 0 then
    --     vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "DiffDelete", 2, 2, -1)
    -- else
    --     vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "String", 2, 2, -1)
    -- end

    -- Highlight status message
    if state.is_updating then
        vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "WarningMsg", status_line, 2, -1)
    else
        vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "String", status_line, 2, -1)
    end

    -- Highlight keybindings
    for i = keybindings_start, keybindings_start + 4 do
        -- find key to get correct length for highlighting
        local key
        if i - keybindings_start == 0 then
            key = config.keys.update
        elseif i - keybindings_start == 1 then
            key = config.keys.install_plugins
        elseif i - keybindings_start == 2 then
            key = config.keys.update_all
        elseif i - keybindings_start == 3 then
            key = config.keys.refresh
        elseif i - keybindings_start == 4 then
            key = config.keys.close
        end
        vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Statement", i, 4, 4 + #key)
    end

    -- Highlight remote commit info
    if #state.remote_commits > 0 then
        vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Title", remote_commit_line, 2, -1)
        -- vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "NonText", remote_commit_line + 1, 2, -1)

        -- Highlight hash and author
        for i = 1, #state.remote_commits do
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Statement", remote_commit_line + i, 2, 3)
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Directory", remote_commit_line + i, 4, 13)
            vim.api.nvim_buf_add_highlight(
                state.buffer,
                ns_id,
                "Special",
                remote_commit_line + i,
                state.remote_commits[i].message:len() + 17,
                -1
            )
        end
        remote_commit_line = remote_commit_line + #state.remote_commits + 1
    end

    -- Highlight plugin update info
    if #state.plugin_updates > 0 then
        vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Title", plugin_update_line, 2, -1)

        -- Highlight plugin names and commits
        for i = 1, #state.plugin_updates do
            local line_num = plugin_update_line + i
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Directory", line_num, 2,
                2 + #state.plugin_updates[i].name)
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Constant", line_num,
                2 + #state.plugin_updates[i].name + 2,
                2 + #state.plugin_updates[i].name + 2 + #state.plugin_updates[i].installed_commit)
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Directory", line_num,
                2 + #state.plugin_updates[i].name + 2 + #state.plugin_updates[i].installed_commit + 5,
                2 + #state.plugin_updates[i].name + 2 + #state.plugin_updates[i].installed_commit + 5 + #state.plugin_updates[i].lockfile_commit)
        end
        plugin_update_line = plugin_update_line + #state.plugin_updates + 1
    end

    -- Highlight log header with a more distinctive color
    vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Special", plugin_update_line, 2, -1)

    -- Highlight commit hashes and current commit indicator
    local log_start = plugin_update_line + 3
    for i, commit in ipairs(state.commits) do
        local line_num = log_start + i - 1

        -- Highlight current commit indicator
        local line = vim.api.nvim_buf_get_lines(state.buffer, line_num, line_num + 1, false)
        local indicator = vim.fn.strcharpart(line[1], 2, 1)
        if indicator == "→" then
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "String", line_num, 2, 3)
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Special", line_num, 4, 13)
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Special", line_num, commit.message:len() + 17, -1)
        else
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Special", line_num, 4, 11)
            vim.api.nvim_buf_add_highlight(state.buffer, ns_id, "Special", line_num, commit.message:len() + 15, -1)
        end
    end

    -- Make buffer non-modifiable again
    vim.api.nvim_buf_set_option(state.buffer, "modifiable", false)
    vim.api.nvim_win_set_height(state.window, math.min(#lines + 1, 60))
    vim.cmd("redraw")
end

-- Get remote commits that are not in the local branch
local function get_remote_commits_not_in_local()
    local branch = get_current_branch()
    local main = config.main_branch
    local compare_with = "origin/" .. main

    -- Get commits that are in remote but not in local
    local cmd = cd_repo_path
        .. "git log -n "
        .. config.log_count
        .. ' --format=format:"%h|%s|%an|%ar" '
        .. compare_with
        .. " ^"
        .. branch

    local result, err = execute_command(cmd)
    if err or not result then
        return {}
    end

    local commits = {}
    for line in result:gmatch("[^\r\n]+") do
        local parts = vim.split(line, "|", { plain = true })
        if #parts >= 4 then
            local hash = vim.trim(parts[1] or "")
            local message = vim.trim(parts[2] or "")
            local author = vim.trim(parts[3] or "")
            local date = vim.trim(parts[4] or "")

            -- Truncate message to first 80 chars and remove any newlines
            message = message:gsub("\r", ""):gsub("\n.*", "")
            if #message > 80 then
                message = message:sub(1, 77) .. "..."
            end

            if hash ~= "" then
                table.insert(commits, {
                    hash = hash,
                    message = message,
                    author = author,
                    date = date,
                })
            end
        end
    end
    return commits
end

function M.refresh()
    -- Get current commit
    state.current_commit = get_current_commit()

    -- Get repository status
    local status = get_repo_status()

    if not status.error then
        state.current_branch = status.branch
        state.ahead_count = status.ahead
        state.behind_count = status.behind

        -- Get remote commits not in local
        state.remote_commits = get_remote_commits_not_in_local()

        -- Check if remote commits exist in current branch
        state.commits_in_branch = are_commits_in_branch(state.remote_commits, state.current_branch)

        -- Set needs_update if there are any remote commits not in local branch
        state.needs_update = #state.remote_commits > 0
    else
        -- Error occurred
        state.needs_update = false
    end

    -- Get commit log
    state.commits, state.log_type = get_commit_log()

    -- Get plugin updates
    state.plugin_updates = get_plugin_updates()
    state.has_plugin_updates = #state.plugin_updates > 0

    -- Render UI
    M.render()

end

function M.open()
    if state.is_open then
        -- Focus existing window
        if vim.api.nvim_win_is_valid(state.window) then
            vim.api.nvim_set_current_win(state.window)
            return
        else
            -- Window was closed unexpectedly
            state.is_open = false
        end
    end

    -- Create window
    M.create_window()

    -- Refresh data and render
    M.refresh()
end

function M.close()
    if state.is_open and state.window and vim.api.nvim_win_is_valid(state.window) then
        vim.api.nvim_win_close(state.window, true)
    end
    state.is_open = false
    state.window = nil
end

function M.check_updates()
    if vim.g.disable_neovim_dotfiles_check_updates then
        return
    end
    local status = get_repo_status()

    if status.error then
        -- Error occurred
        vim.notify(config.notify.error.message, vim.log.levels.ERROR, { title = config.notify.error.title })
        return
    end

    -- Update state
    state.current_branch = status.branch
    state.ahead_count = status.ahead
    state.behind_count = status.behind

    if status.behind > 0 then
        -- Updates available
        local message = config.notify.outdated.message
        if status.ahead > 0 then
            message = "Your branch is ahead by "
                .. status.ahead
                .. " commit(s) and behind by "
                .. status.behind
                .. " commit(s). Press <leader>e to open the updater."
        end

        vim.notify(message, vim.log.levels.WARN, { title = config.notify.outdated.title })
        state.needs_update = true
    else
        -- Up to date with origin
        local message = config.notify.up_to_date.message
        if status.ahead > 0 then
            message = "Your branch is up to date with origin but ahead by " .. status.ahead .. " commits."
        end

        vim.notify(message, vim.log.levels.INFO, { title = config.notify.up_to_date.title })
        state.needs_update = false
    end
end

return M
