# Braintree Keymap Cheatsheet

Up to date as of: 2025-10-14

This cheatsheet is automatically generated. It includes all keymaps from:

- Built-in Neovim defaults
- Custom configuration in [`lua/config/keymaps.lua`](lua/config/keymaps.lua)
- Plugin-specific keymaps from [`lua/plugins/`](lua/plugins/)
- Filetype-specific keymaps from [`ftplugin/`](ftplugin/)

> [!NOTE]
> This cheatsheet does not include keymaps added automatically by configured plugins at runtime, such as those from most legacy vim plugins. To see all keymaps available in your current Neovim session, use the `:map` command, or the `<leader>sk` keymap to open a fuzzy search for keymaps.

## Mode Legend

| Abbreviation | Mode |
|--------------|------|
| n | Normal |
| i | Insert |
| v | Visual and Select |
| x | Visual only |
| s | Select |
| o | Operator-pending |
| t | Terminal |
| c | Command-line |
| ! | Insert & Command-line |

## Mode Changes

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `i` | `n` | Insert before cursor | <sub>Built-in Neovim default</sub> |
| `I` | `n` | Insert at beginning of line | <sub>Built-in Neovim default</sub> |
| `a` | `n` | Append after cursor | <sub>Built-in Neovim default</sub> |
| `A` | `n` | Append at end of line | <sub>Built-in Neovim default</sub> |
| `o` | `n` | Open line below | <sub>Built-in Neovim default</sub> |
| `O` | `n` | Open line above | <sub>Built-in Neovim default</sub> |
| `v` | `n` | Visual mode | <sub>Built-in Neovim default</sub> |
| `V` | `n` | Visual line mode | <sub>Built-in Neovim default</sub> |
| `<C-v>` | `n` | Visual block mode | <sub>Built-in Neovim default</sub> |
| `:` | `n` | Command line | <sub>Built-in Neovim default</sub> |
| `s` | `n` | Substitute character | <sub>Built-in Neovim default</sub> |
| `S` | `n` | Substitute line | <sub>Built-in Neovim default</sub> |

## Motions

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `h` | `n` | Move cursor left | <sub>Built-in Neovim default</sub> |
| `j` | `n` | Move down (account for line wraps) | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `k` | `n` | Move up (account for line wraps) | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `l` | `n` | Move cursor right | <sub>Built-in Neovim default</sub> |
| `w` | `n` | Move to next word beginning | <sub>Built-in Neovim default</sub> |
| `W` | `n` | Move to next WORD beginning | <sub>Built-in Neovim default</sub> |
| `b` | `n` | Move to previous word beginning | <sub>Built-in Neovim default</sub> |
| `B` | `n` | Move to previous WORD beginning | <sub>Built-in Neovim default</sub> |
| `e` | `n` | Move to next word end | <sub>Built-in Neovim default</sub> |
| `E` | `n` | Move to next WORD end | <sub>Built-in Neovim default</sub> |
| `ge` | `n` | Move to previous word end | <sub>Built-in Neovim default</sub> |
| `gE` | `n` | Move to previous WORD end | <sub>Built-in Neovim default</sub> |
| `f` | `n` | Find character forward (use with character) | <sub>Built-in Neovim default</sub> |
| `F` | `n` | Find character backward (use with character) | <sub>Built-in Neovim default</sub> |
| `t` | `n` | Till character forward (use with character) | <sub>Built-in Neovim default</sub> |
| `T` | `n` | Till character backward (use with character) | <sub>Built-in Neovim default</sub> |
| `;` | `n` | Repeat last f/F/T/T | <sub>Built-in Neovim default</sub> |
| `,` | `n` | Repeat last f/F/T/T in opposite direction | <sub>Built-in Neovim default</sub> |
| `0` | `n` | Move to beginning of line | <sub>Built-in Neovim default</sub> |
| `g0` | `n` | Move to beginning of screen line | <sub>Built-in Neovim default</sub> |
| `^` | `n` | Move to first non-blank character of line | <sub>Built-in Neovim default</sub> |
| `g^` | `n` | Move to first non-blank character of screen line | <sub>Built-in Neovim default</sub> |
| `$` | `n` | Move to end of line | <sub>Built-in Neovim default</sub> |
| `g$` | `n` | Move to end of screen line | <sub>Built-in Neovim default</sub> |
| `_` | `n` | Move to first non-blank character of line (with count) | <sub>Built-in Neovim default</sub> |
| `g_` | `n` | Move to last non-blank character of line (with count) | <sub>Built-in Neovim default</sub> |
| `%` | `n` | Move to matching bracket/Tag/Statement | <sub>Built-in Neovim default</sub> |
| `}` | `n` | Next blank line (skip fold) | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `{` | `n` | Previous blank line (skip fold) | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `(` | `n` | Move to previous chunk or newline | <sub>Built-in Neovim default</sub> |
| `)` | `n` | Move to next chunk or newline | <sub>Built-in Neovim default</sub> |
| `gg` | `n` | Go to first line | <sub>Built-in Neovim default</sub> |
| `G` | `n` | Go to last line | <sub>Built-in Neovim default</sub> |

## Edit Operations

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `.` | `n` | Repeat last command | <sub>Built-in Neovim default</sub> |
| `d` | `n` | Delete operator (use with motion) | <sub>Built-in Neovim default</sub> |
| `dd` | `n` | Delete line | <sub>Built-in Neovim default</sub> |
| `D` | `n` | Delete to end of line | <sub>Built-in Neovim default</sub> |
| `c` | `n` | Change operator (use with motion) | <sub>Built-in Neovim default</sub> |
| `cc` | `n` | Change line | <sub>Built-in Neovim default</sub> |
| `C` | `n` | Change to end of line | <sub>Built-in Neovim default</sub> |
| `y` | `n` | Yank to system clipboard | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `yy` | `n` | Yank line to system clipboard | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `Y` | `n` | Yank to system clipboard (line) | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `p` | `n` | Put after cursor | <sub>Built-in Neovim default</sub> |
| `P` | `n` | Put before cursor | <sub>Built-in Neovim default</sub> |
| `u` | `n` | Undo | <sub>Built-in Neovim default</sub> |
| `<C-r>` | `n` | Redo | <sub>Built-in Neovim default</sub> |
| `x` | `n` | Delete character | <sub>Built-in Neovim default</sub> |
| `X` | `n` | Delete character before cursor | <sub>Built-in Neovim default</sub> |
| `r` | `n` | Replace character | <sub>Built-in Neovim default</sub> |
| `J` | `n` | Join lines | <sub>Built-in Neovim default</sub> |
| `>` | `n` | Indent operator (use with motion) | <sub>Built-in Neovim default</sub> |
| `>>` | `n` | Indent line | <sub>Built-in Neovim default</sub> |
| `<` | `n` | De-indent operator (use with motion) | <sub>Built-in Neovim default</sub> |
| `<<` | `n` | De-indent line | <sub>Built-in Neovim default</sub> |
| `=` | `n` | Auto-indent operator (use with motion) | <sub>Built-in Neovim default</sub> |
| `==` | `n` | Auto-indent line | <sub>Built-in Neovim default</sub> |

## Default Text Objects

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `aw` | `n` | Around word | <sub>Built-in Neovim default</sub> |
| `iw` | `n` | Inside word | <sub>Built-in Neovim default</sub> |
| `aW` | `n` | Around WORD | <sub>Built-in Neovim default</sub> |
| `iW` | `n` | Inside WORD | <sub>Built-in Neovim default</sub> |
| `ap` | `n` | Around paragraph | <sub>Built-in Neovim default</sub> |
| `ip` | `n` | Inside paragraph | <sub>Built-in Neovim default</sub> |
| `a)` | `n` | Around parentheses | <sub>Built-in Neovim default</sub> |
| `i)` | `n` | Inside parentheses | <sub>Built-in Neovim default</sub> |
| `a]` | `n` | Around brackets | <sub>Built-in Neovim default</sub> |
| `i]` | `n` | Inside brackets | <sub>Built-in Neovim default</sub> |
| `a}` | `n` | Around braces | <sub>Built-in Neovim default</sub> |
| `i}` | `n` | Inside braces | <sub>Built-in Neovim default</sub> |
| `a"` | `n` | Around double quotes | <sub>Built-in Neovim default</sub> |
| `i"` | `n` | Inside double quotes | <sub>Built-in Neovim default</sub> |
| `a'` | `n` | Around single quotes | <sub>Built-in Neovim default</sub> |
| `i'` | `n` | Inside single quotes | <sub>Built-in Neovim default</sub> |
| `as` | `n` | Around sentence | <sub>Built-in Neovim default</sub> |
| `is` | `n` | Inside sentence | <sub>Built-in Neovim default</sub> |

## Search

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `/` | `n` | Search forward | <sub>Built-in Neovim default</sub> |
| `?` | `n` | Search backward | <sub>Built-in Neovim default</sub> |
| `n` | `n` | Next search match | <sub>Built-in Neovim default</sub> |
| `N` | `n` | Previous search match | <sub>Built-in Neovim default</sub> |
| `*` | `n` `v` | Search forward for word under cursor/Search forward for selection | <sub>Built-in Neovim default</sub> |
| `#` | `n` `v` | Search backward for word under cursor/Search backward for selection | <sub>Built-in Neovim default</sub> |
| `g*` | `n` | Search forward for partial word under cursor | <sub>Built-in Neovim default</sub> |
| `g#` | `n` | Search backward for partial word under cursor | <sub>Built-in Neovim default</sub> |

## Insert Mode

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<Esc>` | `i` | Escape and Clear hlsearch | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `<C-h>` | `i` | Backspace | <sub>Built-in Neovim default</sub> |
| `<C-u>` | `i` | Delete to beginning of line | <sub>Built-in Neovim default</sub> |
| `<C-w>` | `i` | Delete word before cursor | <sub>Built-in Neovim default</sub> |
| `<C-t>` | `i` | Indent line | <sub>Built-in Neovim default</sub> |
| `<C-d>` | `i` | De-indent line | <sub>Built-in Neovim default</sub> |
| `<C-j>` | `i` | New line below | <sub>Built-in Neovim default</sub> |
| `<C-o>` | `i` | Temporarily enter normal mode for single command | <sub>Built-in Neovim default</sub> |
| `<C-r>` | `i` | Insert contents of register (follow with letter of register) | <sub>Built-in Neovim default</sub> |

## Visual Mode

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `d` | `v` | Delete selection | <sub>Built-in Neovim default</sub> |
| `y` | `v` | Yank to system clipboard | [`lua/config/keymaps.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua) |
| `c` | `v` | Change selection | <sub>Built-in Neovim default</sub> |
| `>` | `v` | Increase indentation of selection | <sub>Built-in Neovim default</sub> |
| `<` | `v` | Decrease indentation of selection | <sub>Built-in Neovim default</sub> |
| `=` | `v` | Auto-indent selection | <sub>Built-in Neovim default</sub> |
| `~` | `v` | Toggle case of selection | <sub>Built-in Neovim default</sub> |
| `u` | `v` | Lower case selection | <sub>Built-in Neovim default</sub> |
| `U` | `v` | Upper case selection | <sub>Built-in Neovim default</sub> |

## Macros And Registers

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `q` | `n` | Start recording macro (follow with letter of register)/Stop recording macro | <sub>Built-in Neovim default</sub> |
| `@` | `n` `v` | Execute macro (follow with letter of register) | <sub>Built-in Neovim default</sub> |
| `@@` | `n` | Repeat last executed macro | <sub>Built-in Neovim default</sub> |
| `"` | `n` `v` | Use register (follow with letter of register) | <sub>Built-in Neovim default</sub> |

## Marks

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `m` | `n` | Set mark (follow with letter of register) | <sub>Built-in Neovim default</sub> |
| `'` | `n` | Jump to mark line (follow with letter of register) | <sub>Built-in Neovim default</sub> |
| ``` ` ``` | `n` | Jump to mark position (follow with letter of register) | <sub>Built-in Neovim default</sub> |
| `''` | `n` | Jump to previous mark line | <sub>Built-in Neovim default</sub> |
| ``` `` ``` | `n` | Jump to previous mark position | <sub>Built-in Neovim default</sub> |
| `'.` | `n` | Jump to last change line | <sub>Built-in Neovim default</sub> |
| ``` `. ``` | `n` | Jump to last change position | <sub>Built-in Neovim default</sub> |
| `'[` | `n` | Jump to start of last change/Yank line | <sub>Built-in Neovim default</sub> |
| ``` `[ ``` | `n` | Jump to start of last change/Yank position | <sub>Built-in Neovim default</sub> |
| `']` | `n` | Jump to end of last change/Yank line | <sub>Built-in Neovim default</sub> |
| ``` `] ``` | `n` | Jump to end of last change/Yank position | <sub>Built-in Neovim default</sub> |
| `'<` | `n` | Jump to start of last visual selection line | <sub>Built-in Neovim default</sub> |
| ``` `< ``` | `n` | Jump to start of last visual selection position | <sub>Built-in Neovim default</sub> |
| `'>` | `n` | Jump to end of last visual selection line | <sub>Built-in Neovim default</sub> |
| ``` `> ``` | `n` | Jump to end of last visual selection position | <sub>Built-in Neovim default</sub> |

## Navigation

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<C-d>` | `n` | Scroll down half a screen | <sub>Built-in Neovim default</sub> |
| `<C-u>` | `n` | Scroll up half a screen | <sub>Built-in Neovim default</sub> |
| `<C-e>` | `n` | Scroll down one line | <sub>Built-in Neovim default</sub> |
| `<C-y>` | `n` | Scroll up one line | <sub>Built-in Neovim default</sub> |
| `<C-f>` | `n` | Scroll down one screen | <sub>Built-in Neovim default</sub> |
| `<C-b>` | `n` | Scroll up one screen | <sub>Built-in Neovim default</sub> |
| `zz` | `n` | Center cursor line in window | <sub>Built-in Neovim default</sub> |
| `zt` | `n` | Move cursor line to top of window | <sub>Built-in Neovim default</sub> |
| `zb` | `n` | Move cursor line to bottom of window | <sub>Built-in Neovim default</sub> |
| `gf` | `n` | Go to file under cursor | <sub>Built-in Neovim default</sub> |
| `gF` | `n` | Go to file:line under cursor | <sub>Built-in Neovim default</sub> |
| `g;` | `n` | Go to older change position | <sub>Built-in Neovim default</sub> |
| `g,` | `n` | Go to newer change position | <sub>Built-in Neovim default</sub> |
| `gm` | `n` | Go to middle of screen (horizontally) | <sub>Built-in Neovim default</sub> |
| `M` | `n` | Go to middle of screen (vertically) | <sub>Built-in Neovim default</sub> |
| `gM` | `n` | Go to middle of screen (vertically and horizontally) | <sub>Built-in Neovim default</sub> |
| `<C-o>` | `n` | Jump to older position in jump list | <sub>Built-in Neovim default</sub> |
| `<C-i>` | `n` | Jump to newer position in jump list | <sub>Built-in Neovim default</sub> |
| `<C-^>` | `n` | Jump to alternate file | <sub>Built-in Neovim default</sub> |
| `<C-w>h` | `n` | Move to left window | <sub>Built-in Neovim default</sub> |
| `<C-w>j` | `n` | Move to lower window | <sub>Built-in Neovim default</sub> |
| `<C-w>k` | `n` | Move to upper window | <sub>Built-in Neovim default</sub> |
| `<C-w>l` | `n` | Move to right window | <sub>Built-in Neovim default</sub> |
| `[[` | `n` | Go to previous section | <sub>Built-in Neovim default</sub> |
| `]]` | `n` | Go to next section | <sub>Built-in Neovim default</sub> |

## Folds

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `za` | `n` | Toggle fold under cursor | <sub>Built-in Neovim default</sub> |
| `zA` | `n` | Toggle all folds under cursor recursively | <sub>Built-in Neovim default</sub> |
| `zo` | `n` | Open fold under cursor | <sub>Built-in Neovim default</sub> |
| `zO` | `n` | Open all folds under cursor recursively | <sub>Built-in Neovim default</sub> |
| `zc` | `n` | Close fold under cursor | <sub>Built-in Neovim default</sub> |
| `zC` | `n` | Close all folds under cursor recursively | <sub>Built-in Neovim default</sub> |
| `zf` | `n` `v` | Create fold (with motion/Visual selection)/Create fold from selection | <sub>Built-in Neovim default</sub> |
| `zF` | `n` | Create fold for N lines | <sub>Built-in Neovim default</sub> |
| `zd` | `n` | Delete fold under cursor | <sub>Built-in Neovim default</sub> |
| `zD` | `n` | Delete all folds under cursor recursively | <sub>Built-in Neovim default</sub> |
| `zE` | `n` | Eliminate all folds in window | <sub>Built-in Neovim default</sub> |
| `zi` | `n` | Toggle fold enable/Disable | <sub>Built-in Neovim default</sub> |
| `zj` | `n` | Move to next fold | <sub>Built-in Neovim default</sub> |
| `zk` | `n` | Move to previous fold | <sub>Built-in Neovim default</sub> |
| `zm` | `n` | Fold more (close one fold level) | <sub>Built-in Neovim default</sub> |
| `zM` | `n` | Close all folds | <sub>Built-in Neovim default</sub> |
| `zn` | `n` | Fold none (disable folding) | <sub>Built-in Neovim default</sub> |
| `zN` | `n` | Fold normal (enable folding) | <sub>Built-in Neovim default</sub> |
| `zr` | `n` | Reduce folding (open one fold level) | <sub>Built-in Neovim default</sub> |
| `zR` | `n` | Open all folds | <sub>Built-in Neovim default</sub> |
| `zv` | `n` | View cursor line (open just enough folds) | <sub>Built-in Neovim default</sub> |
| `zx` | `n` | Update folds | <sub>Built-in Neovim default</sub> |
| `zX` | `n` | Undo manually opened/Closed folds | <sub>Built-in Neovim default</sub> |
| `[z` | `n` | Move to start of current open fold | <sub>Built-in Neovim default</sub> |
| `]z` | `n` | Move to end of current open fold | <sub>Built-in Neovim default</sub> |

## Completion

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<C-n>` | `i` | Show/Select Next | [`lua/plugins/coding.lua:126`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L126) |
| `<C-p>` | `i` | Select Prev | [`lua/plugins/coding.lua:127`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L127) |
| `<C-b>` | `i` | Scroll Documentation up | [`lua/plugins/coding.lua:128`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L128) |
| `<C-f>` | `i` | Scroll Documentation down | [`lua/plugins/coding.lua:129`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L129) |
| `<C-space>` | `i` | Show/Show Documentation/Hide Documentation | [`lua/plugins/coding.lua:130`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L130) |
| `<C-e>` | `i` | Cancel | [`lua/plugins/coding.lua:131`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L131) |
| `<C-CR>` | `i` | Cancel/Fallback | [`lua/plugins/coding.lua:132`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L132) |
| `<S-Tab>` | `i` | Snippet Backward/Fallback | [`lua/plugins/coding.lua:145`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L145) |
| `<M-h>` | `i` | Show Documentation/Hide Documentation | [`lua/plugins/coding.lua:164`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L164) |
| `<M-j>` | `i` | Show/Select Next | [`lua/plugins/coding.lua:165`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L165) |
| `<M-k>` | `i` | Select Prev | [`lua/plugins/coding.lua:166`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L166) |
| `<M-l>` | `i` | Select And accept/Utils.cmp.map({ Ai Accept | [`lua/plugins/coding.lua:167`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L167) |
| `<M-;>` | `i` | Cancel | [`lua/plugins/coding.lua:168`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L168) |
| `<Tab>` | `i` | Fallback | [`lua/plugins/coding.lua:173`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L173) |

## Copilot

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>al` | `n` | [a]i [l]ogin | [`lua/plugins/ai.lua:31`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ai.lua#L31) |
| `<leader>aa` | `n` | [a]i [a]sk | [`lua/plugins/ai.lua:59`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ai.lua#L59) |
| `<leader>ap` | `n` | [a]i [p]rompt | [`lua/plugins/ai.lua:60`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ai.lua#L60) |
| `<leader>ae` | `n` | [a]i [e]xplain | [`lua/plugins/ai.lua:61`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ai.lua#L61) |
| `<leader>ar` | `n` | [a]i [r]eview | [`lua/plugins/ai.lua:62`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ai.lua#L62) |
| `<leader>aq` | `n` | [a]i [q]uick chat | [`lua/plugins/ai.lua:64`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ai.lua#L64) |

## Plugin: LSP

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `gd` | `n` | Go To Definition | [`lua/plugins/lsp.lua:41`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L41) |
| `gD` | `n` | Go To Declaration | [`lua/plugins/lsp.lua:42`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L42) |
| `gr` | `n` | Go To References | [`lua/plugins/lsp.lua:43`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L43) |
| `gi` | `n` | Go To Implementation | [`lua/plugins/lsp.lua:44`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L44) |
| `[d` | `n` | Jump To Prev Diagnostic | [`lua/plugins/lsp.lua:45`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L45) |
| `K` | `n` | Hover | [`lua/plugins/lsp.lua:48`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L48) |
| `<C-k>` | `n` | Signature Help | [`lua/plugins/lsp.lua:49`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L49) |
| `gh` | `n` | Toggle Inlay Hints | [`lua/plugins/lsp.lua:50`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L50) |
| `<leader>de` | `n` | Diagnostic Explain | [`lua/plugins/lsp.lua:52`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L52) |
| `<leader>dq` | `n` | Diagnostics To Quickfix | [`lua/plugins/lsp.lua:53`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L53) |
| `<leader>dt` | `n` | Toggle Diagnostics | [`lua/plugins/lsp.lua:54`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L54) |
| `<leader>cD` | `n` | Type Definition | [`lua/plugins/lsp.lua:56`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L56) |
| `<leader>cs` | `n` | Document Symbols | [`lua/plugins/lsp.lua:57`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L57) |
| `<leader>cr` | `n` | Lsp Rename | [`lua/plugins/lsp.lua:58`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L58) |
| `<leader>ca` | `n` | Lsp Code Action | [`lua/plugins/lsp.lua:59`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L59) |
| `<leader>cf` | `n` | Lsp Code Format | [`lua/plugins/lsp.lua:60`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L60) |
| `<leader>ci` | `n` | Lsp Info | [`lua/plugins/lsp.lua:61`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L61) |
| `<leader>cwa` | `n` | Workspace Add Folder | [`lua/plugins/lsp.lua:63`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L63) |
| `<leader>cwr` | `n` | Workspace Remove Folder | [`lua/plugins/lsp.lua:64`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L64) |
| `<leader>cwl` | `n` | Workspace List Folders | [`lua/plugins/lsp.lua:65`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L65) |
| `<leader>ws` | `n` | Workspace Symbols | [`lua/plugins/lsp.lua:66`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L66) |

## Plugin: conform.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>F` | `n` | Format buffer | [`lua/plugins/formatting.lua:14`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/formatting.lua#L14) |

## Plugin: dropbar.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>bo` | `n` | Drop[b]ar - [O]pen Picker | [`lua/plugins/ui.lua:672`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L672) |

## Plugin: eyeliner.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>uf` | `n` | Toggle f/T highlight | [`cosmicbuffalo/lazy_jumpliner_recipe`](https://github.com/cosmicbuffalo/lazy_jumpliner_recipe/blob/main/lazy.lua#L13) |

## Plugin: gitlinker.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>gy` | `n` | Copy GitHub link | [`lua/plugins/utils.lua:216`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L216) |
| `<leader>gY` | `n` | Copy GitHub Repo link | [`lua/plugins/utils.lua:232`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L232) |

## Plugin: gitsigns.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>bl` | `n` | Toggle Line Blame | [`lua/plugins/editor.lua:41`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L41) |
| `<leader>gB` | `n` | Toggle Line Blame | [`lua/plugins/editor.lua:42`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L42) |
| `]h` | `n` | Next git hunk | [`lua/plugins/editor.lua:43`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L43) |
| `ih` | `n` | Select git hunk | [`lua/plugins/editor.lua:45`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L45) |
| `<leader>gr` | `n` | [g]it [r]eset hunk | [`lua/plugins/editor.lua:46`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L46) |
| `<leader>gR` | `n` | [g]it [R]eset buffer | [`lua/plugins/editor.lua:47`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L47) |
| `<leader>gs` | `n` | [g]it [s]tage hunk | [`lua/plugins/editor.lua:48`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L48) |
| `<leader>gS` | `n` | [g]it [S]tage buffer | [`lua/plugins/editor.lua:49`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L49) |
| `<leader>gu` | `n` | [g]it [u]nstage hunk | [`lua/plugins/editor.lua:50`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L50) |
| `<leader>gd` | `n` | [g]it [d]iff this | [`lua/plugins/editor.lua:51`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L51) |
| `<leader>gD` | `n` | [g]it [D]iff this ~ | [`lua/plugins/editor.lua:52`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L52) |

## Plugin: heirline.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>uW` | `n` | Toggle [U]I [W]inbar | [`lua/plugins/ui.lua:725`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L725) |

## Plugin: indent-blankline.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>uI` | `n` | Toggle Indention Guides | [`lua/plugins/utils.lua:29`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L29) |

## Plugin: markdown-preview.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>mp` | `n` | Start Markdown Preview | [`lua/plugins/utils.lua:207`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L207) |
| `<leader>ms` | `n` | Stop Markdown Preview | [`lua/plugins/utils.lua:208`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L208) |
| `<leader>mt` | `n` | Toggle Markdown Preview | [`lua/plugins/utils.lua:209`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L209) |

## Plugin: mason.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>cm` | `n` | Mason | [`lua/plugins/lsp.lua:30`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/lsp.lua#L30) |

## Plugin: mini.bufremove

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>bd` | `n` | Delete Buffer | [`lua/plugins/ui.lua:383`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L383) |
| `<leader>bD` | `n` | Delete Buffer (Force) | [`lua/plugins/ui.lua:404`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L404) |

## Plugin: neo-tree.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>nt` | `n` | Neotree toggle | [`lua/plugins/editor.lua:83`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L83) |
| `<leader>nf` | `n` | Neotree focus file | [`lua/plugins/editor.lua:84`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L84) |

## Plugin: nvim-notify

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>un` | `n` | Dismiss All Notifications | [`lua/plugins/ui.lua:127`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L127) |
| `<leader>uh` | `n` | Notification History | [`lua/plugins/ui.lua:134`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L134) |

## Plugin: nvim-treesitter-context

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>ut` | `n` | Toggle Treesitter Context | [`lua/plugins/treesitter.lua:155`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/treesitter.lua#L155) |

## Plugin: nvim-ufo

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>z` | `n` | Toggle fold | [`cosmicbuffalo/lazy_ufo_recipe`](https://github.com/cosmicbuffalo/lazy_ufo_recipe/blob/main/lazy.lua#L49) |
| `<leader>Z` | `n` | Toggle folds at current indentation level | [`cosmicbuffalo/lazy_ufo_recipe`](https://github.com/cosmicbuffalo/lazy_ufo_recipe/blob/main/lazy.lua#L51) |

## Plugin: resession.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>qs` | `n` | Save Session | [`lua/plugins/editor.lua:124`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L124) |
| `<leader>ql` | `n` | Load Session | [`lua/plugins/editor.lua:125`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L125) |
| `<leader>qd` | `n` | Delete Session | [`lua/plugins/editor.lua:126`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/editor.lua#L126) |

## Plugin: snacks.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>gg` | `n` | Lazygit | [`lua/plugins/utils.lua:97`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L97) |
| `<leader>gb` | `n` | [G]it [B]lame | [`lua/plugins/utils.lua:104`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L104) |
| `<leader>b.` | `n` | New Scratch [b]uffer | [`lua/plugins/utils.lua:111`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L111) |
| `<leader>bS` | `n` | Scratch [b]uffer [S]elect | [`lua/plugins/utils.lua:118`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L118) |

## Plugin: telescope.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader><leader>` | `n` | Find files | [`lua/plugins/ui.lua:411`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L411) |
| `<C-p>` | `n` | Find (git) files | [`lua/plugins/ui.lua:412`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L412) |
| `<leader>be` | `n` | Buffer Explorer | [`lua/plugins/ui.lua:413`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L413) |
| `<leader>gw` | `n` | Grep word in cursor | [`lua/plugins/ui.lua:414`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L414) |
| `<leader>ff` | `n` | Find (git) files | [`lua/plugins/ui.lua:417`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L417) |
| `<leader>fg` | `n` | Find (grep) | [`lua/plugins/ui.lua:418`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L418) |
| `<leader>fb` | `n` | Find Buffers | [`lua/plugins/ui.lua:419`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L419) |
| `<leader>fr` | `n` | Find Recent | [`lua/plugins/ui.lua:420`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L420) |
| `<leader>fh` | `n` | Find help pages | [`lua/plugins/ui.lua:421`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L421) |
| `<leader>fm` | `n` | Find marks | [`lua/plugins/ui.lua:422`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L422) |
| `<leader>fd` | `n` | Document Diagnostics | [`lua/plugins/ui.lua:423`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L423) |
| `<leader>fD` | `n` | Workspace Diagnostics | [`lua/plugins/ui.lua:424`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L424) |
| `<leader>fp` | `n` | Find Plugin File | [`lua/plugins/ui.lua:425`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L425) |
| `<leader>sk` | `n` | Keymaps | [`lua/plugins/ui.lua:427`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L427) |
| `<leader>sa` | `n` | Auto commands | [`lua/plugins/ui.lua:429`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L429) |
| `<leader>sg` | `n` | Grep | [`lua/plugins/ui.lua:430`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L430) |
| `<leader>sb` | `n` | Buffer Fuzzy Find | [`lua/plugins/ui.lua:431`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L431) |
| `<leader>sh` | `n` | Help Pages | [`lua/plugins/ui.lua:432`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L432) |
| `<leader>sC` | `n` | Commands | [`lua/plugins/ui.lua:433`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L433) |
| `<leader>sc` | `n` | Command History | [`lua/plugins/ui.lua:434`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L434) |
| `<leader>so` | `n` | Options | [`lua/plugins/ui.lua:435`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L435) |
| `<leader>sw` | `n` `v` | Word under cursor/Selection | [`lua/plugins/ui.lua:436`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L436) |
| `<leader>sr` | `n` | Resume | [`lua/plugins/ui.lua:438`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua#L438) |
| `d` | `n` | Delete buffer (in buffer explorer) | [`lua/plugins/ui.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua) |
| `<C-e>` | `i` `n` | Scope to directory (with picker open) | [`lua/plugins/ui.lua`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/ui.lua) |
| `<C-n>` | `i` | Next item | Built in telescope default |
| `<Down>` | `i` | Next item | Built in telescope default |
| `<C-p>` | `i` | Previous item | Built in telescope default |
| `<Up>` | `i` | Previous item | Built in telescope default |
| `j` | `n` | Next item | Built in telescope default |
| `k` | `n` | Previous item | Built in telescope default |
| `H` | `n` | Select High | Built in telescope default |
| `M` | `n` | Select Middle | Built in telescope default |
| `L` | `n` | Select Low | Built in telescope default |
| `gg` | `n` | Select the first item | Built in telescope default |
| `G` | `n` | Select the last item | Built in telescope default |
| `<CR>` | `i` `n` | Confirm selection | Built in telescope default |
| `<C-t>` | `i` `n` | Go to file selection in a new tab | Built in telescope default |
| `<C-x>` | `i` `n` | Go to file selection as a split | Built in telescope default |
| `<C-v>` | `i` `n` | Go to file selection as a vsplit | Built in telescope default |
| `<C-u>` | `i` `n` | Scroll up in preview window | Built in telescope default |
| `<C-d>` | `i` `n` | Scroll down in preview window | Built in telescope default |
| `<C-f>` | `i` `n` | Scroll left in preview window | Built in telescope default |
| `<C-k>` | `i` `n` | Scroll right in preview window | Built in telescope default |
| `<M-f>` | `i` `n` | Scroll left in results window | Built in telescope default |
| `<M-k>` | `i` `n` | Scroll right in results window | Built in telescope default |
| `<C-/>` | `i` | Show mappings for picker actions | Built in telescope default |
| `?` | `n` | Show mappings for picker actions | Built in telescope default |
| `<C-c>` | `i` | Close telescope | Built in telescope default |
| `<Esc>` | `n` | Close telescope | Built in telescope default |
| `<Tab>` | `i` `n` | Toggle selection and move to next selection | Built in telescope default |
| `<S-Tab>` | `i` `n` | Toggle selection and move to prev selection | Built in telescope default |
| `<C-q>` | `i` `n` | Send all items not filtered to quickfixlist | Built in telescope default |
| `<M-q>` | `i` `n` | Send all selected items to qflist | Built in telescope default |
| `<C-r><C-w>` | `i` | Insert cword in original window into prompt | Built in telescope default |
| `<C-r><C-a>` | `i` | Insert cWORD in original window into prompt | Built in telescope default |

## Plugin: updater.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>e` | `n` | Open Updater | [`lua/plugins/utils.lua:174`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L174) |

## Plugin: vim-github-url

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>gh` | `n` | Show URL to view the file under cursor on GitHub | [`lua/plugins/legacy.lua:49`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L49) |

## Plugin: vim-rake

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>AA` | `n` | Alternate file | [`lua/plugins/legacy.lua:65`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L65) |
| `<leader>AV` | `n` | Alternate w/ Vertical Split | [`lua/plugins/legacy.lua:66`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L66) |
| `<leader>AS` | `n` | Alternate w/ Horizontal Split | [`lua/plugins/legacy.lua:67`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L67) |

## Plugin: vim-swap

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `g>` | `n` | Swap with next | [`lua/plugins/legacy.lua:106`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L106) |
| `g<` | `n` | Swap with previous | [`lua/plugins/legacy.lua:107`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L107) |
| `gs` | `n` | Swap interactive | [`lua/plugins/legacy.lua:108`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L108) |

## Plugin: vim-test

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>rb` | `n` | Run buffer | [`lua/plugins/legacy.lua:36`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L36) |
| `<leader>rf` | `n` | Run focused | [`lua/plugins/legacy.lua:37`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L37) |
| `<leader>rl` | `n` | Run last test again | [`lua/plugins/legacy.lua:38`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L38) |

## Plugin: vim-unimpaired

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `[a` | `n` | Previous file in argument list | vim-unimpaired built in default |
| `]a` | `n` | Next file in argument list | vim-unimpaired built in default |
| `[A` | `n` | First file in argument list | vim-unimpaired built in default |
| `]A` | `n` | Last file in argument list | vim-unimpaired built in default |
| `[b` | `n` | Previous buffer | vim-unimpaired built in default |
| `]b` | `n` | Next buffer | vim-unimpaired built in default |
| `[B` | `n` | First buffer | vim-unimpaired built in default |
| `]B` | `n` | Last buffer | vim-unimpaired built in default |
| `[l` | `n` | Previous location list item | vim-unimpaired built in default |
| `]l` | `n` | Next location list item | vim-unimpaired built in default |
| `[L` | `n` | First location list item | vim-unimpaired built in default |
| `]L` | `n` | Last location list item | vim-unimpaired built in default |
| `[<C-L>` | `n` | Previous location file | vim-unimpaired built in default |
| `]<C-L>` | `n` | Next location file | vim-unimpaired built in default |
| `[q` | `n` | Previous quickfix item | vim-unimpaired built in default |
| `]q` | `n` | Next quickfix item | vim-unimpaired built in default |
| `[Q` | `n` | First quickfix item | vim-unimpaired built in default |
| `]Q` | `n` | Last quickfix item | vim-unimpaired built in default |
| `[<C-Q>` | `n` | Previous quickfix file | vim-unimpaired built in default |
| `]<C-Q>` | `n` | Next quickfix file | vim-unimpaired built in default |
| `[t` | `n` | Previous tag | vim-unimpaired built in default |
| `]t` | `n` | Next tag | vim-unimpaired built in default |
| `[T` | `n` | First tag | vim-unimpaired built in default |
| `]T` | `n` | Last tag | vim-unimpaired built in default |
| `[<C-T>` | `n` | Previous preview tag | vim-unimpaired built in default |
| `]<C-T>` | `n` | Next preview tag | vim-unimpaired built in default |
| `[f` | `n` | Previous file in directory | vim-unimpaired built in default |
| `]f` | `n` | Next file in directory | vim-unimpaired built in default |
| `[n` | `n` | Previous SCM conflict marker | vim-unimpaired built in default |
| `]n` | `n` | Next SCM conflict marker | vim-unimpaired built in default |
| `[<Space>` | `n` | Add blank lines above | vim-unimpaired built in default |
| `]<Space>` | `n` | Add blank lines below | vim-unimpaired built in default |
| `[e` | `n` `v` | Exchange line up/Exchange selection up | vim-unimpaired built in default |
| `]e` | `n` `v` | Exchange line down/Exchange selection down | vim-unimpaired built in default |
| `[ob` | `n` | Set background=dark | vim-unimpaired built in default |
| `]ob` | `n` | Set background=light | vim-unimpaired built in default |
| `yob` | `n` | Toggle background | vim-unimpaired built in default |
| `[oc` | `n` | Enable cursorline | vim-unimpaired built in default |
| `]oc` | `n` | Disable cursorline | vim-unimpaired built in default |
| `yoc` | `n` | Toggle cursorline | vim-unimpaired built in default |
| `[od` | `n` | Enable diff | vim-unimpaired built in default |
| `]od` | `n` | Disable diff | vim-unimpaired built in default |
| `yod` | `n` | Toggle diff | vim-unimpaired built in default |
| `[oh` | `n` | Enable hlsearch | vim-unimpaired built in default |
| `]oh` | `n` | Disable hlsearch | vim-unimpaired built in default |
| `yoh` | `n` | Toggle hlsearch | vim-unimpaired built in default |
| `[oi` | `n` | Enable ignorecase | vim-unimpaired built in default |
| `]oi` | `n` | Disable ignorecase | vim-unimpaired built in default |
| `yoi` | `n` | Toggle ignorecase | vim-unimpaired built in default |
| `[ol` | `n` | Enable list | vim-unimpaired built in default |
| `]ol` | `n` | Disable list | vim-unimpaired built in default |
| `yol` | `n` | Toggle list | vim-unimpaired built in default |
| `[on` | `n` | Enable number | vim-unimpaired built in default |
| `]on` | `n` | Disable number | vim-unimpaired built in default |
| `yon` | `n` | Toggle number | vim-unimpaired built in default |
| `[or` | `n` | Enable relativenumber | vim-unimpaired built in default |
| `]or` | `n` | Disable relativenumber | vim-unimpaired built in default |
| `yor` | `n` | Toggle relativenumber | vim-unimpaired built in default |
| `[os` | `n` | Enable spell | vim-unimpaired built in default |
| `]os` | `n` | Disable spell | vim-unimpaired built in default |
| `yos` | `n` | Toggle spell | vim-unimpaired built in default |
| `[ot` | `n` | Enable colorcolumn | vim-unimpaired built in default |
| `]ot` | `n` | Disable colorcolumn | vim-unimpaired built in default |
| `yot` | `n` | Toggle colorcolumn | vim-unimpaired built in default |
| `[ou` | `n` | Enable cursorcolumn | vim-unimpaired built in default |
| `]ou` | `n` | Disable cursorcolumn | vim-unimpaired built in default |
| `you` | `n` | Toggle cursorcolumn | vim-unimpaired built in default |
| `[ov` | `n` | Enable virtualedit | vim-unimpaired built in default |
| `]ov` | `n` | Disable virtualedit | vim-unimpaired built in default |
| `yov` | `n` | Toggle virtualedit | vim-unimpaired built in default |
| `[ow` | `n` | Enable wrap | vim-unimpaired built in default |
| `]ow` | `n` | Disable wrap | vim-unimpaired built in default |
| `yow` | `n` | Toggle wrap | vim-unimpaired built in default |
| `[ox` | `n` | Enable crosshairs | vim-unimpaired built in default |
| `]ox` | `n` | Disable crosshairs | vim-unimpaired built in default |
| `yox` | `n` | Toggle crosshairs | vim-unimpaired built in default |
| `>p` | `n` | Paste after with increased indent | vim-unimpaired built in default |
| `>P` | `n` | Paste before with increased indent | vim-unimpaired built in default |
| `<p` | `n` | Paste after with decreased indent | vim-unimpaired built in default |
| `<P` | `n` | Paste before with decreased indent | vim-unimpaired built in default |
| `=p` | `n` | Paste after with reindent | vim-unimpaired built in default |
| `=P` | `n` | Paste before with reindent | vim-unimpaired built in default |
| `[op` | `n` | Paste line above with paste mode | vim-unimpaired built in default |
| `]op` | `n` | Paste line below with paste mode | vim-unimpaired built in default |
| `yop` | `n` | Paste at cursor with paste mode | vim-unimpaired built in default |
| `[x` | `n` `v` | XML encode (motion)/XML encode selection | vim-unimpaired built in default |
| `]x` | `n` `v` | XML decode (motion)/XML decode selection | vim-unimpaired built in default |
| `[xx` | `n` | XML encode line | vim-unimpaired built in default |
| `]xx` | `n` | XML decode line | vim-unimpaired built in default |
| `[u` | `n` `v` | URL encode (motion)/URL encode selection | vim-unimpaired built in default |
| `]u` | `n` `v` | URL decode (motion)/URL decode selection | vim-unimpaired built in default |
| `[uu` | `n` | URL encode line | vim-unimpaired built in default |
| `]uu` | `n` | URL decode line | vim-unimpaired built in default |
| `[y` | `n` `v` | C string encode (motion)/C string encode selection | vim-unimpaired built in default |
| `]y` | `n` `v` | C string decode (motion)/C string decode selection | vim-unimpaired built in default |
| `[yy` | `n` | C string encode line | vim-unimpaired built in default |
| `]yy` | `n` | C string decode line | vim-unimpaired built in default |
| `[C` | `n` `v` | C string encode (motion)/C string encode selection | vim-unimpaired built in default |
| `]C` | `n` `v` | C string decode (motion)/C string decode selection | vim-unimpaired built in default |
| `[CC` | `n` | C string encode line | vim-unimpaired built in default |
| `]CC` | `n` | C string decode line | vim-unimpaired built in default |

## Plugin: vimux

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>rx` | `n` | Close runner pane | [`lua/plugins/legacy.lua:25`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L25) |
| `<leader>ri` | `n` | Inspect runner pane | [`lua/plugins/legacy.lua:26`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L26) |
| `<leader>vs` | `n` `v` | Run contiguous lines/Run highlighted | [`lua/plugins/legacy.lua:28`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/legacy.lua#L28) |

## Plugin: windows.nvim

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>wm` | `n` | Maximize window (toggle) | [`lua/plugins/utils.lua:139`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L139) |
| `<leader>wh` | `n` | Maximize window horizontally | [`lua/plugins/utils.lua:140`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L140) |
| `<leader>wv` | `n` | Maximize window vertically | [`lua/plugins/utils.lua:141`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L141) |
| `<leader>we` | `n` | Equalize windows | [`lua/plugins/utils.lua:142`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L142) |
| `<leader>wa` | `n` | Toggle window autowidth | [`lua/plugins/utils.lua:143`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L143) |
| `<C-w>a` | `n` | Toggle window autowidth | [`lua/plugins/utils.lua:144`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L144) |
| `<leader>ww` | `n` | Other Window | [`lua/plugins/utils.lua:146`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L146) |
| `<leader>wd` | `n` | Delete Window | [`lua/plugins/utils.lua:152`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/utils.lua#L152) |

## Miscellaneous

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>nh` | `n` | Removes text searching highlight | [`lua/config/keymaps.lua:3`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L3) |
| `<esc>` | `i` | Escape and Clear hlsearch | [`lua/config/keymaps.lua:5`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L5) |
| `<leader>l` | `n` | Lazy | [`lua/config/keymaps.lua:7`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L7) |
| `<leader>cc` | `n` | Comments the current or highlighted lines | [`lua/config/keymaps.lua:15`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L15) |
| `<leader>cw` | `n` | Remove trailing whitespace | [`lua/config/keymaps.lua:18`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L18) |
| `,` | `i` | Insert comma with undo breakpoint | [`lua/config/keymaps.lua:24`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L24) |
| `.` | `i` | Insert period with undo breakpoint | [`lua/config/keymaps.lua:25`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L25) |
| `;` | `i` | Insert semicolon with undo breakpoint | [`lua/config/keymaps.lua:26`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L26) |
| `p` | `x` | Paste (without overwrite register) | [`lua/config/keymaps.lua:38`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L38) |
| `<leader>dv` | `n` | [d]iagnotic [v]irtual lines toggle | [`lua/config/keymaps.lua:50`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L50) |
| `<leader>uw` | `n` | Toggle Wrap | [`lua/config/keymaps.lua:62`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L62) |
| `<leader>bb` | `n` | Switch to Other Buffer | [`lua/config/keymaps.lua:67`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L67) |
| `<leader>qq` | `n` | Quit All | [`lua/config/keymaps.lua:69`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L69) |
| `<leader>va` | `n` | Select All | [`lua/config/keymaps.lua:71`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L71) |
| `<leader>vp` | `n` | Select Pasted Text | [`lua/config/keymaps.lua:73`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L73) |
| `<leader>-` | `n` | Split Window Below | [`lua/config/keymaps.lua:75`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L75) |
| `<leader>\|` | `n` | Split Window Right | [`lua/config/keymaps.lua:76`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L76) |
| `zh` | `n` | Half screen to the left | [`lua/config/keymaps.lua:78`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L78) |
| `zl` | `n` | Half screen to the right | [`lua/config/keymaps.lua:79`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L79) |
| `<PageDown>` | `n` | Page down | [`lua/config/keymaps.lua:84`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L84) |
| `<leader>fn` | `n` | New File | [`lua/config/keymaps.lua:86`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L86) |
| `<leader>fx` | `n` | Make executable | [`lua/config/keymaps.lua:88`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L88) |
| `<leader>fy` | `n` | Copy Relative Path | [`lua/config/keymaps.lua:100`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L100) |
| `<leader>fY` | `n` | Copy Path | [`lua/config/keymaps.lua:101`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L101) |
| `<leader>gp` | `n` | Copy GitHub PR URL for current branch | [`lua/config/keymaps.lua:136`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L136) |
| `<leader>gP` | `n` | Copy GitHub PR URL for line blame (gh cli) | [`lua/config/keymaps.lua:170`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L170) |
| `<leader>uT` | `n` | Toggle Treesitter Highlighting | [`lua/config/keymaps.lua:173`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/config/keymaps.lua#L173) |
| `v` | `v` | Align markdown table | [`lua/plugins/coding.lua:208`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/lua/plugins/coding.lua#L208) |

## Ruby

| Keymap | Mode | Description | Source |
|--------|------|-------------|--------|
| `<leader>rd` | `n` | [r]uby [d]ebug: binding.pry line under cursor | [`ftplugin/ruby.lua:2`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/ftplugin/ruby.lua#L2) |
| `<leader>rs` | `n` | [r]uby [s]yntax: check the syntax of the current file | [`ftplugin/ruby.lua:3`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/ftplugin/ruby.lua#L3) |
| `<leader>rD` | `n` | [r]uby [D]elete binding.pry lines in current buffer | [`ftplugin/ruby.lua:28`](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/main/ftplugin/ruby.lua#L28) |