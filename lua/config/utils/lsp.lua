local M = {}

function M.setup_on_attach(on_attach_fn)
    return vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                on_attach_fn(client, buffer)
            end
        end
    })
end

return M
