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
    set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: [g]o to [D]eclaration" })
    set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: [g]o to [d]efinition" })
    set("n", "<Leader>D", vim.lsp.buf.type_definition, { desc = "LSP: type [D]efinition" })
    set("n", "<Leader>cf", vim.lsp.buf.format, { desc = "LSP: [c]ode [f]ormat" })

    -- Information
    set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "LSP: Hover" })
    set({ "n", "i" }, "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end,
        { desc = "LSP: Signature help" })
    set("n", "gh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        { desc = "LSP: Toggle inlay hints" })
    set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: [g]o to [i]mplementation" })
    set("n", "gr", vim.lsp.buf.references, { desc = "LSP: [g]o to [r]eferences" })
    set("n", "<Leader>ds", vim.lsp.buf.document_symbol, { desc = "LSP: [d]ocument [s]ymbol" })

    -- -- Diagnostics
    set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
        { desc = "LSP: jump to previous [d]iagnostic" })
    set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
        { desc = "LSP: jump to next [d]iagnostic" })
    set("n", "<Leader>e", vim.diagnostic.open_float, { desc = "LSP: diagnostic [e]xplain" })
    set("n", "<Leader>q", vim.diagnostic.setloclist, { desc = "LSP: add buffer diagnostics to [q]uickfix" })

    -- Refactoring
    set("n", "<Leader>rn", vim.lsp.buf.rename, { desc = "LSP: [r]e[n]ame" })
    set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [c]ode [a]ction" })

    -- Workspaces
    set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP: [w]orkspace [a]dd folder" })
    set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP: [w]orkspace [r]emove folder" })
    set("n", "<Leader>wl", function() vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        { desc = "LSP: [w]orkspace folders [l]ist" })
    set("n", "<Leader>ws", vim.lsp.buf.workspace_symbol, { desc = "LSP: [w]orkspace [s]ymbol" })
end

return M
