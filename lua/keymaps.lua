-- Normal mode mapping for removing highlight from text search
vim.keymap.set('n', '<Leader>nh', '<cmd>nohls<cr>', { desc = "Removes text searching highlight" })

-- Normal and visual mode mapping for removing highlight from text search
vim.keymap.set({'n', 'v'}, '<Leader>cc', '<cmd>normal gcc<cr>', { desc = "Comments the current or highlighted lines" })
