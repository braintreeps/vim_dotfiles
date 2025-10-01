# `ftdetect`

From [the docs](https://neovim.io/doc/user/filetype.html#ftdetect):

> The files in the `ftdetect` directory are used after all the default
> checks, thus they can overrule a previously detected file type.

For filename-based detection, the docs show this (non-Lua) example:

> Create a file that contains an autocommand to detect the file type.
> Example:
>
> ```vim
> au BufRead,BufNewFile *.mine		set filetype=mine
> ```

For content-based detection, you need an autocommand to inspect the file
contents using a callback function that reads the file and checks for specific
patterns. Lua example for detecting based on shebang contents:

```lua
local augroup = vim.api.nvim_create_augroup
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = augroup("filename_here", { clear = true }),
    pattern = "*",
    callback = function()
        local first_line = vim.fn.getline(1)
        if first_line and first_line:match("^#!/.*LANGUAGE_COMMAND_HERE") then
            vim.bo.filetype = "LANGUAGE_NAME_HERE"
        end
    end,
})
```

## Our usage

Please use `ftdetect` files *only* to detect filetypes that are either:

* not recognized by an existing filetype plugin, or
* misdetected as the wrong filetype.

Keep in mind that (in most circumstances) you can just add a comment to your
file that includes a `ft` directive (e.g. `#vim:ft=ansible:`,) so please only
set these up for common-enough use cases that apply universally.

Do not use them to set language or plugin-specific options. For configuring
settings after a filetype is detected, use [`ftplugin`][] files instead.

For key-mappings and options that are meant to be global (neither
plugin-specific, nor language specific) please place them in the
[usual](../lua/keymaps.lua) [places](../lua/options.lua).

The file name doesn't matter, unlike with [`ftplugin`][]; you can use any
descriptive name that explains what the detection does. However, please use
the same name for the file as you do for the augroup for your autocmd.
(Example: [`uv_python.lua`](uv_python.lua) uses the `uv_python` augroup.)


[`ftplugin`]: ../ftplugin/
