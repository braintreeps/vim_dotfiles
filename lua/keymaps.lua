local map = vim.keymap.set
-- Normal mode mapping for removing highlight from text search
map('n', '<Leader>nh', '<cmd>nohls<cr>', { desc = "Removes text searching highlight" })

-- Normal and visual mode mapping for removing highlight from text search
map({'n', 'v'}, '<Leader>cc', '<cmd>normal gcc<cr>', { desc = "Comments the current or highlighted lines" })

-- Remove trailing whitespace
map('n', '<Leader>cw', '<cmd>%s/\\s\\+$//e<cr>', { desc = "Remove trailing whitespace" })

-- More granular undo breakpoints
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Account for line wraps when moving the cursor up/down
map("n", "k", "gk")
map("n", "j", "gj")

-- Paste over a selection without overwriting clipboard
map("x", "p", function()
  return "pgv\"" .. vim.v.register .. "y"
end, { expr = true, noremap = true, desc = "Paste (without overwrite register)" })

