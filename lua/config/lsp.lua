local M = {}

-- stylua: ignore
function M.on_attach(_client, bufnr, opts)
    --- Sets keymaps with default options
    --- @param modes string|string[]
    --- @param lhs string
    --- @param rhs string|function
    --- @param opts? table
    local function set(modes, lhs, rhs, opts)
        -- passing something other than a string will disable the keymap
        if type(lhs) ~= "string" then
            return
        end
        local defaults = { noremap = true, silent = true, buffer = bufnr }
        local local_opts = vim.tbl_deep_extend("force", defaults, opts or {})

        vim.keymap.set(modes, lhs, rhs, local_opts)
    end
    -- clean up default neovim LSP keymaps
    pcall(vim.keymap.del, "n", "gra")
    pcall(vim.keymap.del, "x", "gra")
    pcall(vim.keymap.del, "n", "gri")
    pcall(vim.keymap.del, "n", "grn")
    pcall(vim.keymap.del, "n", "grr")

    -- Navigation
    set(
        "n",
        opts.keymap.go_to_declaration,
        vim.lsp.buf.declaration,
        { desc = "LSP: [g]o to [D]eclaration" }
    )
    set(
        "n",
        opts.keymap.go_to_definition,
        vim.lsp.buf.definition,
        { desc = "LSP: [g]o to [d]efinition" }
    )
    set(
        "n",
        opts.keymap.go_to_implementation,
        vim.lsp.buf.implementation,
        { desc = "LSP: [g]o to [i]mplementation" }
    )
    set(
        "n",
        opts.keymap.go_to_references,
        vim.lsp.buf.references,
        { desc = "LSP: [g]o to [r]eferences" }
    )

    -- Information
    set(
        "n",
        opts.keymap.hover,
        function() vim.lsp.buf.hover({ border = "rounded" }) end,
        { desc = "LSP: Hover" }
    )
    set(
        { "n", "i" },
        opts.keymap.signature_help,
        function() vim.lsp.buf.signature_help({ border = "rounded" }) end,
        { desc = "LSP: Signature help" }
    )
    set(
        "n",
        opts.keymap.toggle_inlay_hints,
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        { desc = "LSP: Toggle inlay hints" }
    )
    set(
        "n",
        opts.keymap.document_symbols,
        vim.lsp.buf.document_symbol,
        { desc = "LSP: [d]ocument [s]ymbol" }
    )
    set(
        "n",
        opts.keymap.lsp_info,
        '<cmd>LspInfo<cr>',
        { desc = "LSP: server [i]nfo" }
    )
    set(
        "n",
        opts.keymap.type_definition,
        vim.lsp.buf.type_definition,
        { desc = "LSP: type [D]efinition" }
    )
    set(
        "n",
        opts.keymap.lsp_code_format,
        vim.lsp.buf.format,
        { desc = "LSP: [c]ode [f]ormat" }
    )
    -- Diagnostics
    set(
        "n",
        opts.keymap.jump_to_prev_diagnostic,
        function() vim.diagnostic.jump({ count = -1, float = true }) end,
        { desc = "LSP: jump to previous [d]iagnostic" }
    )
    set(
        "n",
        opts.keymap.jump_to_next_diagnostic,
        function() vim.diagnostic.jump({ count = 1, float = true }) end,
        { desc = "LSP: jump to next [d]iagnostic" }
    )
    set(
        "n",
        opts.keymap.diagnostic_explain,
        vim.diagnostic.open_float,
        { desc = "LSP: [d]iagnostic [e]xplain" }
    )
    set(
        "n",
        opts.keymap.diagnostics_to_quickfix,
        vim.diagnostic.setloclist,
        { desc = "LSP: add buffer diagnostics to [q]uickfix" }
    )
    set(
        "n",
        opts.keymap.toggle_diagnostics,
        function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
        { desc = "[d]iagnostics [t]oggle" }
    )

    -- Refactoring
    set(
        "n",
        opts.keymap.lsp_rename,
        vim.lsp.buf.rename,
        { desc = "LSP: [r]ename" }
    )
    set(
        "n",
        opts.keymap.lsp_code_action,
        vim.lsp.buf.code_action,
        { desc = "LSP: [c]ode [a]ction" }
    )

    -- Workspaces
    set(
        "n",
        opts.keymap.workspace_add_folder,
        vim.lsp.buf.add_workspace_folder,
        { desc = "LSP: [w]orkspace [a]dd folder" }
    )
    set(
        "n",
        opts.keymap.workspace_remove_folder,
        vim.lsp.buf.remove_workspace_folder,
        { desc = "LSP: [w]orkspace [r]emove folder" }
    )
    set(
        "n",
        opts.keymap.workspace_list_folders,
        function()
            vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        { desc = "LSP: [w]orkspace [l]ist folders" }
    )
    set(
        "n",
        opts.keymap.workspace_symbols,
        vim.lsp.buf.workspace_symbol,
        { desc = "LSP: [w]orkspace [s]ymbol" }
    )
end

return M
