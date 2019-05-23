## Overview

Clone this project directy into `~/.vim`:

```bash
# Clean up old unnecessary files or symlinks
rm -f ~/.vimrc ~/.gvimrc ~/.vimrc.bundles; rm -rf ~/.vim

# Clone directly into ~/.vim
git clone git@github.com:braintreeps/vim_dotfiles ~/.vim
```

After cloning this project, run `~/.vim/activate.sh`.

Uses `vim-plug` to manage bundles.

## Default Shortcuts

The file explorer - NERD Tree:

```
\nt - open/close NERD Tree
\nf - reveal the current file in NERD Tree
\nr - refresh the contents of NERT Tree (can also use r or R to refresh a folder)
? - in NERD Tree to see all its shortcuts
```

File search - fzf:

```
\ff - find a file
\fb - find an open buffer
\ft - find ctags
```

Comments (watch out for \'s):

```
gc<motion> - toggle comments
gcc - toggle comments on the current line
\cc - toggle comments
\uc - toggle comments
```

Vimux (must be inside a tmux)

```
\vp - prompt for a command to run in vimux
\vs - send the block of code to the vimux window
\rl - run the last command
```

Jump to definition - CTags

```
CTRL+] - jump to definition
g CTRL+] - pop up a selector if there is more than one definition; if there is only one, jump there
\rt - rebuild tags
```

Git Grep - Fugitive

```
\gw - git grep for the word under the cursor
```

Whitespace

```
\cw - clean up trailing whitespace at the end of the line
```

Ruby Specific Mappings

```
\rb - run all specs in current buffer
\rc - run all specs in current context
\rf - run the spec under the cursor
\rl - run the last spec
\rs - syntax check the current file
```

Python-Specific Mappings

```
\rb - run all tests in the current buffer (pytest or nose)
\rf - run the current test
\rl - run the last test
```
