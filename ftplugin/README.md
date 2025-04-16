# ftplugin

From [the docs](https://neovim.io/doc/user/filetype.html):

> Vim can detect the type of file that is edited.  This is done by checking the
file name and sometimes by inspecting the contents of the file for specific
text.

> Each time a new or existing file is edited, Vim will try to recognize the type
of the file and set the 'filetype' option.  This will trigger the FileType
event, which can be used to set the syntax highlighting, set options, etc.

All keymappings and options set here will be local to the buffer at `BufNewFile` and `BufRead`
events and will not used for other files.

## Our usage

Please use ftplugin/language.lua files to only set options and keymappings that are specific to a
particular language, e.g. ruby.

Do not use them to set plugin-specific keymappings. For a `vim-rails` keymapping, place that in
the [plugin spec](../lua/plugins/), etc.

For key-mappings and options that are meant to be global (neither plugin-specific, nor language
specific) please place them in the [usual](../lua/keymaps.lua) [places](../lua/options.lua).
