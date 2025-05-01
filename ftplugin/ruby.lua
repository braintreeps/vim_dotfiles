-- mnemonic: ruby-debug
vim.keymap.set("", "<LocalLeader>rd", "Orequire 'pry'; binding.pry<ESC>", { desc = "[r]uby [d]ebug: binding.pry line under cursor" })
vim.keymap.set("n", "<silent> <LocalLeader>rs", ":!ruby -c %<CR>", { desc = "[r]uby [s]yntax: check the syntax of the current file" })
