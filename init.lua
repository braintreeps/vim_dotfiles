local Utils = require("config.utils")
-- set up options and any personal options
require("config.options")
if Utils.config_path_exists("/lua/personal/options.lua") then
    require("personal.options")
end

require("config.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

local lazy_spec = {
    { import = "plugins" },
}

if Utils.config_path_exists("/lua/personal/plugins") then
    -- lua indices start at 1, so we load our custom plugins after the base plugins
    table.insert(lazy_spec, 2, { import = "personal.plugins" })
end

require("lazy").setup({
    spec = lazy_spec,
    change_detection = {
        notify = false,
    },
})

-- Set up LSPs
vim.lsp.config("*", {
    on_attach = require("config.lsp").on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Configure lua_ls to allow unused variables prefixed with '_'
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                unusedLocalExclude = { "_*" }, -- Allow variables/arguments starting with '_' to be unused
            },
        },
    },
})

vim.lsp.enable(require("config.lsp").default_lsp_servers)

-- Load auto commands
require("config.autocmds")

-- Any post-plugin configurations can be added
if Utils.config_path_exists("/lua/personal/init.lua") then
    require("personal.init")
end
