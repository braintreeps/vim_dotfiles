local map = vim.keymap.set
-- Normal mode mapping for removing highlight from text search
map("n", "<Leader>nh", "<cmd>nohls<cr>", { desc = "Removes text searching highlight" })
-- clear search highlights with esc
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
-- open lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Open dotfiles updater TUI
map("n", "<Leader>e", function()
    require("config.dotfiles_updater").open()
end, { desc = "Open dotfiles updater" })

-- Normal and visual mode mapping for commenting lines
map({ "n", "v" }, "<Leader>cc", "<cmd>normal gcc<cr>", { desc = "Comments the current or highlighted lines" })

-- Remove trailing whitespace
map("n", "<Leader>cw", "<cmd>%s/\\s\\+$//e<cr>", { desc = "Remove trailing whitespace" })

-- For those who hold shift too long
vim.api.nvim_create_user_command("W", "w", {})

-- More granular undo breakpoints
map("i", ",", ",<c-g>u", { desc = "Insert comma with undo breakpoint" })
map("i", ".", ".<c-g>u", { desc = "Insert period with undo breakpoint" })
map("i", ";", ";<c-g>u", { desc = "Insert semicolon with undo breakpoint" })

-- Default yank to system clipboard
map({ "n", "v" }, "y", '"+y', { noremap = true, silent = true, desc = "Yank to system clipboard" })
map("n", "yy", '"+yy', { noremap = true, silent = true, desc = "Yank line to system clipboard" })
map({ "n", "v" }, "Y", '"+Y', { noremap = true, silent = true, desc = "Yank to system clipboard (line)" })

-- Account for line wraps when moving the cursor up/down
map("n", "k", "gk", { desc = "Move up (account for line wraps)" })
map("n", "j", "gj", { desc = "Move down (account for line wraps)" })

-- Paste over a selection without overwriting clipboard
map("x", "p", function()
    return 'pgv"' .. vim.v.register .. "y"
end, { expr = true, noremap = true, desc = "Paste (without overwrite register)" })

-- make } and { skip over folds instead of opening them
map("n", "{", function()
    return vim.fn.foldclosed(vim.fn.search("^$", "Wnb")) == -1 and "{" or "{k"
end, { expr = true, noremap = true, desc = "Previous blank line (skip fold)" })
map("n", "}", function()
    return vim.fn.foldclosed(vim.fn.search("^$", "Wn")) == -1 and "}" or "}j"
end, { expr = true, noremap = true, desc = "Next blank line (skip fold)" })

map("n", "<leader>dv", function()
    local current_config = vim.diagnostic.config()
    local new_virtual_lines = not current_config.virtual_lines
    vim.diagnostic.config({ virtual_lines = new_virtual_lines })
    if new_virtual_lines then
        vim.notify("Diagnostic virtual lines enabled", vim.log.levels.INFO, { title = "Diagnostics" })
    else
        vim.notify("Diagnostic virtual lines disabled", vim.log.levels.WARN, { title = "Diagnostics" })
    end
end, { noremap = true, desc = "[d]iagnotic [v]irtual lines toggle" })

-- Toggle wrap
map("n", "<leader>uw", function()
    require("config.utils").toggle_option("wrap")
end, { noremap = true, desc = "Toggle Wrap" })

-- Switch between last two used buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- convenient quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
-- select all
map("n", "<Leader>va", "ggVG", { desc = "Select All" })
-- select last paste
map("n", "<leader>vp", "`[v`]", { desc = "Select Pasted Text" })
-- convenient window splitting
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- viewport movement
map("n", "zh", "zH", { desc = "Half screen to the left" })
map("n", "zl", "zL", { desc = "Half screen to the right" })
-- keep cursor centered when moving half page up/down
map("n", "<C-d>", "<C-d>zz^", { desc = "Scroll Down" })
map("n", "<C-u>", "<C-u>zz^", { desc = "Scroll Up" })
-- keep PageDown from scrolling further than necessary
map("n", "<PageDown>", "<C-d>zz", { desc = "Page down" })
-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
-- create executables
map("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })
-- copy paths
function copy_relative_path()
    local path = require("config.utils").relative_path()
    vim.fn.setreg("+", path)
    vim.notify("Copied relative path to clipboard: " .. path)
end
function copy_path()
    local path = require("config.utils").path()
    vim.fn.setreg("+", path)
    vim.notify("Copied path to clipboard: " .. path)
end
map("n", "<leader>fy", copy_relative_path, { desc = "Copy Relative Path" })
map("n", "<leader>fY", copy_path, { desc = "Copy Path" })

local function copy_github_pr_url()
    -- Get remote URL
    local handle = io.popen("git remote get-url origin 2>/dev/null")
    local remote_url = handle:read("*a"):gsub("%s+$", "")
    handle:close()

    if remote_url == "" then
        vim.notify("No git remote found", vim.log.levels.ERROR)
        return
    end

    -- Extract owner/repo
    local owner, repo = remote_url:match("[:/]([^/]+)/([^%.]+)%.git$")
    if not owner or not repo then
        vim.notify("Could not parse remote URL", vim.log.levels.ERROR)
        return
    end

    -- Get current branch
    handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    local branch = handle:read("*a"):gsub("%s+$", "")
    handle:close()

    if branch == "" then
        vim.notify("No git branch found", vim.log.levels.ERROR)
        return
    end

    local url = string.format("https://github.com/%s/%s/pull/new/%s", owner, repo, branch)

    vim.fn.setreg("+", url)
    vim.notify("Copied PR URL to clipboard: " .. url)
end
map("n", "<leader>gp", copy_github_pr_url, { desc = "Copy GitHub PR URL for current branch", silent = true })

local function copy_merged_pr_url()
    local file = vim.fn.expand("%")
    local line = vim.fn.line(".")

    -- Get the commit SHA for the current line using git blame
    local sha = vim.fn.systemlist(
        "git blame -L "
            .. vim.fn.line(".")
            .. ","
            .. vim.fn.line(".")
            .. " "
            .. vim.fn.expand("%")
            .. ' --porcelain | cut -d " " -f 1'
    )[1]

    if sha and sha ~= "" then
        -- Get the PR number associated with the commit SHA using gh
        local pr_number = vim.fn.systemlist(
            'gh pr list --search "' .. sha .. '" --state "merged" --json number --jq ".[0].number"'
        )[1]
        if pr_number and pr_number ~= "" then
            local pr_url = vim.fn.system("gh browse " .. pr_number .. " -n")
            vim.notify("PR URL: " .. pr_url)
            vim.fn.setreg("+", pr_url)
        else
            vim.notify("No PR found for this commit.", vim.log.levels.WARN)
        end
    else
        vim.notify("No commit found for this line.", vim.log.levels.WARN)
    end
end
--stylua: ignore
map("n", "<leader>gP", copy_merged_pr_url, { desc = "Copy GitHub PR URL for line blame (gh cli)", silent = true })
