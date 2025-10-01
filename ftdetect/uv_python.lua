-- Detect Python files with `uv run` shebang
-- https://docs.astral.sh/uv/guides/scripts/#using-a-shebang-to-create-an-executable-file
local augroup = vim.api.nvim_create_augroup
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = augroup("uv_python", { clear = true }),
    pattern = "*",
    callback = function()
        local first_line = vim.fn.getline(1)
        if first_line and first_line:match("^#!/.*uv run") then
            vim.bo.filetype = "python"
        end
    end,
})
