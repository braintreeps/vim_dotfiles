local M = {}

--- List of servers to automatically install, configure, and enable.
---@type string[]
M.default_lsp_servers = {
    "bashls",
    "lua_ls",
}

function M.on_attach(_, bufnr)
    --- Sets keymaps with default options
    --- @param modes string|string[]
    --- @param lhs string
    --- @param rhs string|function
    --- @param opts? table
    local function set(modes, lhs, rhs, opts)
        local defaults = { noremap = true, silent = true, buffer = bufnr }
        local local_opts = vim.tbl_deep_extend("force", defaults, opts or {})

        vim.keymap.set(modes, lhs, rhs, local_opts)
    end

    -- Navigation
    set("n", "gD", vim.lsp.buf.declaration)
    set("n", "gd", vim.lsp.buf.definition)
    set("n", "<Leader>D", vim.lsp.buf.type_definition)
    set("n", "<Leader>cf", vim.lsp.buf.format)

    -- Information
    set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "Hover" })
    set({ "n", "i" }, "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end,
        { desc = "Signature help" })
    set("n", "gh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
    set("n", "gi", vim.lsp.buf.implementation)
    set("n", "gr", vim.lsp.buf.references)
    set("n", "<Leader>ds", vim.lsp.buf.document_symbol)

    -- -- Diagnostics
    set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true}) end)
    set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true}) end)
    set("n", "<Leader>e", vim.diagnostic.open_float)
    set("n", "<Leader>q", vim.diagnostic.setloclist)

    -- Refactoring
    set("n", "<Leader>rn", vim.lsp.buf.rename)
    set("n", "<Leader>ca", vim.lsp.buf.code_action)

    -- Workspaces
    set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder)
    set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder)
    set("n", "<Leader>wl", function() vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
    set("n", "<Leader>ws", vim.lsp.buf.workspace_symbol)
end

return M
