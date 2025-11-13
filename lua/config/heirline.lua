local M = {}
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local function h(name)
    return utils.get_highlight(name)
end
M.get_highlight = h

local function get_dropbar_winbar_content()
    return "%{%v:lua.dropbar()%}"
end

local function is_parent_window(parent_id, child_id)
    local child_win_config = vim.api.nvim_win_get_config(child_id)
    if child_win_config.relative ~= "win" then
        return false
    end

    if child_win_config.win == parent_id then
        return true
    end

    if not vim.api.nvim_win_is_valid(child_win_config.win) then
        return false
    end

    return is_parent_window(parent_id, child_win_config.win)
end

local function is_active_or_parent()
    local win_id = vim.api.nvim_get_current_win()

    local curwin = tonumber(vim.g.actual_curwin)
    if curwin == nil then
        return win_id == curwin
    end

    if is_parent_window(win_id, curwin) then
        return true
    end

    return win_id == curwin
end

function M.build_winbar(opts)
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
    local Align = { provider = "%=" }
    local Space = { provider = " " }

    -- Begin FileNameBlock construction
    -- This component is the main display for inactive windows
    local FileNameBlock = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
    }

    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color =
                require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end,
    }

    local FileName = {
        provider = function(self)
            local filename = vim.fn.fnamemodify(self.filename, ":.")
            if filename == "" then
                return "[No Name]"
            end

            if not conditions.width_percent_below(#filename, 0.25) then
                filename = vim.fn.pathshorten(filename)
            end

            return filename
        end,
    }

    local FileFlags = {
        {
            condition = function()
                return vim.bo.modified
            end,
            provider = " [+]",
            hl = { fg = h(get_h_map().modified).fg, bold = true },
        },
    }

    local FileNameModifier = {
        hl = function()
            if vim.bo.modified then
                return { fg = h(get_h_map().modified).fg, bold = true, force = true }
            end

            return { fg = h(get_h_map().bright_fg).fg }
        end,
    }

    -- stylua: ignore
    FileNameBlock = utils.insert(
        FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifier, FileName),
        FileFlags,
        { provider = "%<" }
    )
    -- End FileNameBlock construction

    local InactiveWinbar = {
        condition = function()
            return conditions.is_not_active() and not is_active_or_parent()
        end,
        {
            Space,
            FileNameBlock,
            Align,
        },
    }

    -- local component_separators = { left = "", right = "" }
    local section_separators = { left = "", right = "" }
    local mode_colors = opts.mode_colors
    local get_mode_colors
    if type(mode_colors) == "function" then
        get_mode_colors = mode_colors
        mode_colors = get_mode_colors()
    else
        get_mode_colors = function()
            return mode_colors
        end
    end

    -- The mode wrappers sync with lualine to add more visual indication
    -- for the current window and mode
    local ModeWrapStart = {
        init = function(self)
            self.mode = vim.fn.mode(1)
            self.short_mode = self.mode:sub(1, 1)
            self.mode_colors = get_mode_colors()
        end,
        static = {
            inactive_color = opts.inactive_color,
        },
        {
            provider = " ",
            hl = function(self)
                if conditions.is_not_active() then
                    return { bg = self.inactive_color }
                end
                return { bg = self.mode_colors[self.short_mode] }
            end,
        },
        {
            provider = section_separators.left,
            hl = function(self)
                if conditions.is_not_active() then
                    return { fg = self.inactive_color }
                end
                return { fg = self.mode_colors[self.short_mode] }
            end,
        },
    }
    local ModeWrapEnd = {
        init = function(self)
            self.mode = vim.fn.mode(1)
            self.short_mode = self.mode:sub(1, 1)
            self.mode_colors = get_mode_colors()
        end,
        static = {
            inactive_color = opts.inactive_color,
        },
        {
            provider = section_separators.right,
            hl = function(self)
                if conditions.is_not_active() then
                    return { fg = self.inactive_color }
                end
                return { fg = self.mode_colors[self.short_mode] }
            end,
        },
        {
            provider = " ",
            hl = function(self)
                if conditions.is_not_active() then
                    return { bg = self.inactive_color }
                end
                return { bg = self.mode_colors[self.short_mode] }
            end,
        },
    }

    local ActiveWinbar = {
        condition = function()
            return is_active_or_parent()
        end,
        {
            {
                provider = function()
                    return get_dropbar_winbar_content()
                end,
            },
            Align,
            FileFlags,
            Space,
        },
    }

    local DefaultWinbar = {
        opts.enable_mode_wrapper and ModeWrapStart or {},
        ActiveWinbar,
        InactiveWinbar,
        opts.enable_mode_wrapper and ModeWrapEnd or {},
    }

    local SpecialWinbar = {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix", "trouble", "neo-tree" },
            })
        end,
    }

    return {
        fallthrough = false,
        SpecialWinbar,
        DefaultWinbar,
    }
end

function M.build_opts(opts)
    return {
        disable_winbar_cb = function(args)
            if vim.g.disable_fancy_winbar then
                return true
            end
            return conditions.buffer_matches({
                buftype = opts.winbar_disabled_buftypes,
                filetype = opts.winbar_disabled_filetypes,
            })
        end,
    }
end

function M.toggle_winbar()
    if vim.g.disable_fancy_winbar then
        vim.g.disable_fancy_winbar = false
        vim.api.nvim_exec_autocmds("VimEnter", {})
        vim.notify("Fancy winbar enabled", vim.log.levels.INFO, { title = "heirline.nvim" })
    else
        vim.g.disable_fancy_winbar = true
        vim.api.nvim_exec_autocmds("VimEnter", {})
        vim.notify("Fancy winbar disabled", vim.log.levels.WARN, { title = "heirline.nvim" })
    end
end

return M
