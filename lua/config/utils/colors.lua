-- Utility functions related to dealing with colors and color schemes
local M = {}

function M.open_colorscheme_picker()
    -- We need to use the picker function out of this plugin in order to get the
    -- persistence logic on selection of a new colorscheme
    if require("config.utils.lazy").get_plugin("telescope-colorscheme-persist.nvim") then
        require("telescope-colorscheme-persist").picker()
    else
        require("telescope.builtin").colorscheme()
    end
end

M.SwitchColorschemeKeyMap = { "<leader>uC", M.open_colorscheme_picker, desc = "Colorscheme with preview" }

function M.current_colorscheme(persisted)
    local current = vim.g.colors_name

    if require("config.utils.lazy").get_plugin("telescope-colorscheme-persist") then
        local current_persisted = require("telescope-colorscheme-persist").get_colorscheme()

        if persisted then
            return current_persisted
        end
    end

    return current
end

function M.get_mode_colors()
    local current_colorscheme = M.current_colorscheme()
    local inkline_colors = {
        n = "orange",
        i = "green",
        v = "magenta",
        V = "magenta",
        ["\22"] = "magenta",
        c = "gold",
        s = "orange",
        S = "orange",
        ["\19"] = "orange",
        R = "red",
        r = "red",
        ["!"] = "gray",
        t = "teal",
    }
    local tokyonight_colors = {
        n = "blue",
        i = "green",
        v = "purple",
        V = "purple",
        ["\22"] = "purple",
        c = "yellow",
        s = "orange",
        S = "orange",
        ["\19"] = "orange",
        R = "red",
        r = "red",
        ["!"] = "gray",
        t = "gray",
    }
    local defaults = {
        inkline = inkline_colors,
        ["tokyonight"] = tokyonight_colors,
        ["tokyonight-day"] = tokyonight_colors,
        ["tokyonight-moon"] = tokyonight_colors,
        ["tokyonight-storm"] = tokyonight_colors,
        ["tokyonight-night"] = tokyonight_colors,
    }
    return defaults[current_colorscheme] or defaults.inkline
end

function M.get_highlight_mappings()
    local current_colorscheme = M.current_colorscheme()
    local inkline_highlight_mappings = {
        bright_bg = "Folded",
        bright_fg = "Folded",
        red = "DiagnosticError",
        dark_red = "DiffDelete",
        green = "String",
        blue = "Function",
        gray = "NonText",
        orange = "Keyword",
        yellow = "Todo",
        purple = "Statement",
        cyan = "Special",
        diag_warn = "DiagnosticWarn",
        diag_error = "DiagnosticError",
        diag_hint = "DiagnosticHint",
        diag_info = "DiagnosticInfo",
        git_del = "diffDeleted",
        git_add = "diffAdded",
        git_change = "diffChanged",
        modified = "CursorLineNr",
    }
    local tokyonight_highlight_mappings = {
        bright_bg = "Folded",
        bright_fg = "Folded",
        red = "DiagnosticError",
        dark_red = "DiffDelete",
        green = "String",
        blue = "Function",
        gray = "NonText",
        orange = "Constant",
        yellow = "Todo",
        purple = "Statement",
        cyan = "Special",
        diag_warn = "DiagnosticWarn",
        diag_error = "DiagnosticError",
        diag_hint = "DiagnosticHint",
        diag_info = "DiagnosticInfo",
        git_del = "diffDeleted",
        git_add = "diffAdded",
        git_change = "diffChanged",
        modified = "CursorLineNr",
    }
    local defaults = {
        inkline = inkline_highlight_mappings,
        ["tokyonight"] = tokyonight_highlight_mappings,
        ["tokyonight-day"] = tokyonight_highlight_mappings,
        ["tokyonight-moon"] = tokyonight_highlight_mappings,
        ["tokyonight-storm"] = tokyonight_highlight_mappings,
        ["tokyonight-night"] = tokyonight_highlight_mappings,
    }
    return defaults[current_colorscheme] or defaults.inkline
end

function M.setup_heirline_colors(opts)
    local heirline_config = require("config.heirline")
    local h_map = opts.color_highlight_mappings
    local get_h_map
    if type(h_map) == "function" then
        get_h_map = h_map
        h_map = get_h_map()
    else
        get_h_map = function()
            return h_map
        end
    end
    local h = heirline_config.get_highlight
    return {
        bright_bg = h(h_map.bright_bg).bg,
        bright_fg = h(h_map.bright_fg).fg,
        red = h(h_map.red).fg,
        dark_red = h(h_map.dark_red).bg,
        green = h(h_map.green).fg,
        blue = h(h_map.blue).fg,
        gray = h(h_map.gray).fg,
        orange = h(h_map.orange).fg,
        yellow = h(h_map.yellow).bg,
        purple = h(h_map.purple).fg,
        cyan = h(h_map.cyan).fg,
        diag_warn = h(h_map.diag_warn).fg,
        diag_error = h(h_map.diag_error).fg,
        diag_hint = h(h_map.diag_hint).fg,
        diag_info = h(h_map.diag_info).fg,
        git_del = h(h_map.git_del).fg,
        git_add = h(h_map.git_add).fg,
        git_change = h(h_map.git_change).fg,
    }
end

return M
