require("options")
require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local personal_plugins_exist = vim.uv.fs_stat(vim.fn.stdpath("config") .. "/lua/personal/plugins") ~= nil
if personal_plugins_exist then
	require("lazy").setup({
		spec = {
			{ import = "plugins" },
			{ import = "personal.plugins" },
		}
	})
else
	require("lazy").setup("plugins")
end

local personal_init_exists = vim.uv.fs_stat(vim.fn.stdpath("config") .. "/lua/personal/init.lua") ~= nil
if personal_init_exists then
	require("personal.init")
end
