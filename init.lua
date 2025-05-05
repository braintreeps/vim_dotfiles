local Utils = require("lazy_utils")
-- set up options and any personal options
require("options")
if Utils.config_path_exists("/lua/personal/options.lua") then
    require("personal.options")
end

require("keymaps")

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
    on_attach = require("lsp_config").on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.lsp.enable(require("lsp_config").default_lsp_servers)

-- Load auto commands
require("autocmds")

-- Any post-plugin configurations can be added
if Utils.config_path_exists("/lua/personal/init.lua") then
    require("personal.init")
end
