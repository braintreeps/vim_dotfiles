local map = vim.keymap.set
-- Normal mode mapping for removing highlight from text search
map('n', '<Leader>nh', '<cmd>nohls<cr>', { desc = "Removes text searching highlight" })

-- Open dotfiles updater TUI
map('n', '<Leader>e', function() require("config.dotfiles_updater").open() end, { desc = "Open dotfiles updater" })

-- Normal and visual mode mapping for commenting lines
map({'n', 'v'}, '<Leader>cc', '<cmd>normal gcc<cr>', { desc = "Comments the current or highlighted lines" })

-- Remove trailing whitespace
map('n', '<Leader>cw', '<cmd>%s/\\s\\+$//e<cr>', { desc = "Remove trailing whitespace" })

-- For those who hold shift too long
vim.api.nvim_create_user_command('W', 'w', {})

-- More granular undo breakpoints
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Default yank to system clipboard
map({"n", "v"}, "y", '"+y', { noremap = true, silent = true })
map("n", "yy", '"+yy', { noremap = true, silent = true })
map({"n", "v"}, "Y", '"+Y', { noremap = true, silent = true })

-- Account for line wraps when moving the cursor up/down
map("n", "k", "gk")
map("n", "j", "gj")

-- Paste over a selection without overwriting clipboard
map("x", "p", function()
  return "pgv\"" .. vim.v.register .. "y"
end, { expr = true, noremap = true, desc = "Paste (without overwrite register)" })

-- make } and { skip over folds instead of opening them
map('n', '{', function()
  return vim.fn.foldclosed(vim.fn.search('^$', 'Wnb')) == -1 and '{' or '{k'
end, { expr = true, noremap = true, desc = "Previous blank line (skip fold)" })
map('n', '}', function()
  return vim.fn.foldclosed(vim.fn.search('^$', 'Wn')) == -1 and '}' or '}j'
end, { expr = true, noremap = true, desc = "Next blank line (skip fold)"})
