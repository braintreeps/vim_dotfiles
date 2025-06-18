vim.opt.number = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.completeopt = "menuone,noselect,popup"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { current_line = true },
})
vim.opt.autoread = false
vim.opt.mouse = ''
vim.opt.undofile = true
vim.g.disable_fancy_winbar = true

vim.g.clipboard = "osc52"
