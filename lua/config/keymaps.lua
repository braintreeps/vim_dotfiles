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
