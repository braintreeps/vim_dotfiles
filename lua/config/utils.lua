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

function M.toggle_option(option, values)
    if values then
        if vim.opt_local[option]:get() == values[1] then
            vim.opt_local[option] = values[2]
        else
            vim.opt_local[option] = values[1]
        end
        return vim.notify(
            "Set " .. option .. " to " .. vim.opt_local[option]:get(),
            { title = "Option", level = vim.log.levels.INFO }
        )
    end
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if vim.opt_local[option]:get() then
        vim.notify("Enabled " .. option, { title = "Option", level = vim.log.levels.INFO })
    else
        vim.notify("Disabled " .. option, { title = "Option", level = vim.log.levels.WARN })
    end
end

function M.set_tracked_window()
    local winid = vim.api.nvim_get_current_win()
    local file = io.open("/tmp/nvim_tracked_window", "w")
    if file then
        file:write(tostring(winid))
        file:close()
    end
end

function M.open_in_tracked_window(filename)
    local file = io.open("/tmp/nvim_tracked_window", "r")
    if not file then
        vim.cmd("edit " .. vim.fn.fnameescape(filename))
        return
    end

    local winid = tonumber(file:read("*l"))
    file:close()

    if winid and vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_set_current_win(winid)
    end
    vim.cmd("edit " .. vim.fn.fnameescape(filename))
end

function M.relative_path()

  local current_dir = vim.fn.expand("%:p:h")
  vim.fn.chdir(current_dir)

  -- Attempt to get the git root directory
  local root_dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file_path = vim.fn.expand("%:p")
  local relative_path

  if vim.v.shell_error == 0 then
    -- If inside a git repository
    relative_path = file_path:sub(#root_dir + 2)
  else
    -- If not inside a git repository, make path relative to home directory
    local home_dir = os.getenv("HOME")
    if file_path:find(home_dir) == 1 then
      relative_path = "~" .. file_path:sub(#home_dir + 1)
    else
      relative_path = file_path -- Use absolute path as a fallback
    end
  end
  return relative_path
end

function M.path()
  local current_dir = vim.fn.expand("%:p:h")
  vim.fn.chdir(current_dir)

  local file_path = vim.fn.expand("%:p")
  local relative_path

  local home_dir = os.getenv("HOME")
  if file_path:find(home_dir) == 1 then
    relative_path = "~" .. file_path:sub(#home_dir + 1)
  else
    relative_path = file_path -- Use absolute path as a fallback
  end

  return relative_path
end

return M
