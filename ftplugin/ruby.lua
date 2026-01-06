-- mnemonic: ruby-debug
vim.keymap.set(
    "",
    "<LocalLeader>rd",
    "Orequire 'pry'; require 'pry-byebug'; binding.pry<ESC>",
    { desc = "[r]uby [d]ebug: binding.pry line under cursor" }
)
vim.keymap.set(
    "n",
    "<LocalLeader>rs",
    ":!ruby -c %<CR>",
    { desc = "[r]uby [s]yntax: check the syntax of the current file", silent = true }
)

local function remove_binding_pry()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local new_lines = {}
    local removed_count = 0

    for _, line in ipairs(lines) do
        if not string.find(line, "binding%.pry") then
            table.insert(new_lines, line)
        else
            removed_count = removed_count + 1
        end
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)

    if removed_count > 0 then
        vim.notify(string.format("Removed %d line(s) containing binding.pry", removed_count), vim.log.levels.INFO)
    else
        vim.notify("No binding.pry lines found", vim.log.levels.WARN)
    end
end

vim.keymap.set(
    "n",
    "<LocalLeader>rD",
    remove_binding_pry,
    { desc = "[r]uby [D]elete binding.pry lines in current buffer" }
)

local function test_context()
    vim.cmd("wall")
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("RubyBlockSpecParentContext")
    vim.cmd("TestNearest")
    vim.api.nvim_win_set_cursor(0, pos)
end

vim.keymap.set("", "<LocalLeader>rc", test_context, { desc = "Run context", silent = true })
