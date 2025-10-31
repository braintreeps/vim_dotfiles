-- Utility functions for related to working with Lazy.nvim
local M = {}

M.LazyFileEvents = { "BufReadPost", "BufNewFile", "BufWritePre" }

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
