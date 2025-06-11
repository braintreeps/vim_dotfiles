local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
    group = augroup("highlight_yank", { clear = true}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Check if neovim-dotfiles are up to date on startup
autocmd("VimEnter", {
    group = augroup("check_dotfiles_updates", { clear = true }),
    callback = function()
        -- Defer the check to ensure Neovim is fully loaded
        vim.defer_fn(function()
            require("config.dotfiles_updater").check_updates()
        end, 1000)
    end,
})
