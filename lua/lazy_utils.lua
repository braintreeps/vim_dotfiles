local M = {}

M.LazyFileEvents = { "BufReadPost", "BufNewFile", "BufWritePre" }
M.SwitchColorschemeKeyMap = {
	"<leader>uC",
	function()
		require("telescope.builtin").colorscheme({ enable_preview = true })
	end,
	desc = "Colorscheme with preview",
}

function M.config_path_exists(path)
	return vim.uv.fs_stat(vim.fn.stdpath("config").. path) ~= nil
end

function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end


return M
