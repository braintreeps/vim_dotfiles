-- This Utils module is a collection of utility functions and submodules
-- submodules are organized by their functionality and loaded on demand
local M = {}

setmetatable(M, {
  __index = function(t, k)

    t[k] = require("config.utils." .. k)
    return t[k]
  end,
})

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

function M.config_path_exists(path)
    return vim.uv.fs_stat(vim.fn.stdpath("config") .. path) ~= nil
end

return M
