# Getting Started with This Neovim Config

Welcome to Neovim! This guide aims to get you familiar with the Braintree Neovim config. Think of it as your roadmap from "I just opened Neovim" to "I'm coding like a pro."

> [!TIP]
> This getting started guide assumes you have at least some familiarity with vim, so if you're an absolute beginner, check out [ESSENTIAL_VIM](./ESSENTIAL_VIM.md) for a first timer's guide! Feel free to also check out some youtube tutorials to learn the basics - The Primeagen has [a pretty good intro series](https://www.youtube.com/playlist?list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R).
>
> Some essential default vim commands are still called out below (marked with ^! like `<foo>`<sup>!</sup>), but if you're a total vim noob, you should spend some time learning the vim motion basics before diving into this guide about Braintree's customized Neovim config.

## 🎯 Your First 5 Minutes

Start here! These tips and shortcuts will immediately make you productive:

### Know your `<Leader>` key!
- By default, this neovim config has `\`<sup>!</sup> as its `<Leader>` key
  - `<Space>` is another common leader key, and many devs using this config have it set up as an "alternate" leader key
    - If you'd like to see how to customize your leader key, check out [LEADER_KEYS](./LEADER_KEYS.md)

> [!TIP]
> Most of the keymaps mentioned in this guide start with the `<Leader>` key. When you see something like `<Leader>ff`, what that means is you'll first press `<Leader>` (meaning `\`, or space, if configured), then `f` and then `f` again.

### Explore `which-key`!
- This neovim config uses a plugin called `which-key` that acts as an on-demand cheatsheet for discovering or re-discovering keybinds AS you type them!

- Give it a try by hitting your `<Leader>` key and it will show you all the available keybinds that could follow `<Leader>`.
  - For "groups" of keybinds that are nested under another key after `<Leader>`, these group labels are displayed in the popup with a different color.
  - You cancel any "partial" keybind you've started with `<ESC>` to close the menu
  - You can also navigate backward through this popup with `<BS>` (backspace), so feel free to dive in and take a look around!
    - *Pro tip: hitting `<Leader>` and then `<BS>` will show you the available keybinds in `NORMAL` mode in the which-key popup*

### Finding Your Files
- **`<Leader>ff`** / **`<Leader><Leader>`** - Find files by name
  - *Just type part of a filename - try typing "read" to find README.md*
- **`<Leader>fb`** / **`<Leaedr>be`** - Switch between files (buffers) you have open
  - *Much faster than clicking tabs!*
- **`<Leader>fr`** - Find files you've recently opened
  - *Similar to `<Leader>fb`, but also includes recent files you've already closed*

### Basic Navigation
- **`<Leader>nt`** - Open/close the file tree on the left
- **`<Leader>nf`** - Find your current file in the tree
  - *Useful when you're lost and want to see where you are*
- **`<Leader>bb`** - Back to previous file (buffer)
- **`<C-o>`<sup>!</sup>** - Back to an older position (previous location in jump list)
- **`<C-i>`<sup>!</sup>** - Forward to a newer position (next location in jump list)

### Managing Panes/Windows
- **`<C-w>s`<sup>!</sup>** - Create a horizontal split (new window below)
- **`<C-w>v`<sup>!</sup>** - Create a vertical split (new window to right)
- **`<C-w>p`<sup>!</sup>** / **`<Leader>ww`** - Switch to your previous window
- **`<C-w>c`<sup>!</sup>** / **`<Leader>wd`** - Close your current window
- **`<C-w>h`<sup>!</sup>** - Move to the window to the left of the current one
- **`<C-w>j`<sup>!</sup>** - Move to the window below the current one
- **`<C-w>k`<sup>!</sup>** - Move to the window above the current one
- **`<C-w>l`<sup>!</sup>** - Move to the window to the right of the current one


## 🔍 Searching Like a Pro

Once you're comfortable with the basics:

- **`<Leader>fg`** / **`<Leader>sg`** - Search for text across your entire project
  - *Example: Search "login" to find all login-related code*
- **`<Leader>sr`** - Resume your last search
  - *Search for something, scroll through results and pick one, then hit this keymap to get right back to your search results*
- **`<C-e>`** - Scope your search (_[e]nter directory_)
  - *(hold down `control`, then press `e`, **WHILE** a search picker is open, then fuzzy find a directory to scope to)*
  - *Example: Search for a method name only in `/app` or only in `/spec`*
- **`<Leader>sb`** - Fuzzy find text in your current file
  - *like a more typo-tolerant `/`, with previews and line numbers!*
- **`<C-q>`** - Add any search's results to the quickfix list
  - *Operate on your results with `:cdo`, or just save your results for later!*

## ✏️ Essential Editing

### Quick Actions
- **`<Leader>cc`** / **`gcc`** - Comment/uncomment lines
  - *Works on the current line or highlighted text*
  - *You can also use `gc` as an operator, try `gc2j` (comment this line and the next two down) or `gcip` (comment inside paragraph)!*
- **`y`** / **`yy`** - Copy (yank) to your computer's clipboard
  - *Unlike basic vim, this actually copies to your system clipboard*

### Autocompletion
##### All these completion keymaps are available in `INSERT` mode AND `COMMAND` mode!

- **`<C-n>`** / **`<M-j>`** - Open/scroll down in the completion menu
- **`<C-p>`** / **`<M-k>`** - Scroll up in the completion menu
- **`<C-e>`** / **`<M-;>`** - Close the completion menu
- **`<Tab>`** / **`<M-l>`** - Accept a completion suggestion
- **`<M-h>`** - Show/hide documentation for completion suggestions

>[!TIP]
> When a keymap starts with `<C-`, that means you should hold down `control`, then press the following key.
>
> When a keymap starts with `<M-`, that means you should hold down `option` (or `alt` on some keyboards), then press the key.
> These `option`-prefixed completion keymaps are very handy if you're used to the vim `hjkl` patterns already!

### Clean Up Your Code
- **`<Leader>cf`** - Make your code look pretty (auto-format)
- **`<Leader>cw`** - Remove extra spaces at the end of lines
  - *`<Leader>cf` does this too, but this one's handy if there isn't a formatter set up for your language*

## 🤖 Smart Code Features (LSP)

**What's LSP?** LSP stands for "Language Server Protocol" - it's what makes Neovim understand your programming language. It knows about functions, variables, and can catch errors.

For more information on getting started with LSPs, check out our [LSP Guide](./LSP_GUIDE.md)!

These features work automatically once you open a code file:

### Understanding Code
- **`gd`** - Jump to where something is defined
  - *Click on a function name, press `gd` to see the actual function*
- **`K`** - Show documentation about what your cursor is on
  - *Like a tooltip that explains what a function does*
- **`gr`** - Find everywhere something is used
  - *See all the places a function is called*

### Finding Problems
When you see red squiggly lines (errors):
- **`<Leader>fd`** - Find errors in the current file
- **`<Leader>fD`** - Find errors accross the entire project
- **`[d`** / **`]d`** - Jump between errors (diagnostics) in the current file
- **`<Leader>cd`** - Show diagnostic details for the current line *(also displays in the bottom status line)*
- **`<Leader>dt`** - Toggle diagnostics on/off
  - *Sometimes LSPs just really don't like whatever you're doing, and you want the noise to go away*

### Refactoring
- **`<Leader>ca`** - Show available fixes for a diagnostic
  - *Often can auto-fix imports, typos, and common mistakes*
- **`<Leader>cr`** - Rename a variable/function everywhere
  - *Changes the name in all files - safe refactoring, as long as the LSP supports it*
  - *NOTE: `ruby-lsp` can have trouble with this, so make sure to double check its work!*

## 🧪 Testing Your Code

Perfect for when you're writing tests or want to run them:

- **`<Leader>rf`** - Run the current test file
- **`<Leader>rl`** - Run the last test again
- **`<Leader>rb`** - Run all tests in your project

## 🎓 Intermediate Features

Once you're comfortable with the basics:

### Git Integration
- **`<Leader>bl`** - Toggle current line blame (on by default)
  - *Great for finding who to ask about confusing code*
- **`<Leader>gb`** - Show full git blame for the current linegitsigns
- **`<Leader>gg`** - Open the `Lazygit` TUI directly inside neovim!
  - *If you're unfamiliar with Lazygit, check out [this guide on freecodecamp](https://www.freecodecamp.org/news/how-to-use-lazygit-to-improve-your-git-workflow/) or this [video from Josean Martinez](https://www.youtube.com/watch?v=Ihg37znaiBo)*
- **`:Gitsigns`** - Gitsigns provides lots of cool functionality
  - *Check out [the plugin repo](https://github.com/lewis6991/gitsigns.nvim) to see what it can do! You can use it via command mode, or create your own custom keymaps*
  - *We may include more `Gitsigns` keymaps by default in the future*

### AI Tooling
- **`<Leader>al`** - Log into GitHub Copilot
- **`<Leader>aa`** - Open the copilot chat panel

### Advanced Finding
- **`<Leader>gw`** - Grep for the word under your cursor
- **`<Leader>cs`** - Show document outline (functions, classes, etc.)
- **`<Leader>ws`** - Search symbols across your whole project
- **`<Leader>sk`** - Search for keymaps by mapping or description
- **`<Leader>sh`** - Search vim help tags
- **`<Leader>s"`** - Search vim registers
- **`<Leader>sc`** - Search your vim command history
- **`<Leader>sC`** - Search for available vim commands

### Resizing windows
- **`<Leader>wm`** - "Maximize" the current window
- **`<Leader>wh`** - "Maximize" the current window horizontally
- **`<Leader>wv`** - "Maximize" the current window vertically
- **`<Leader>we`** - "Equalize" window sizes (spread panes out evenly)
- **`<C-w>a`** / **`<Leader>wa`** - Toggle window auto-resize behavior

### Managing Your Workspace
- **`<Leader>e`** - Open the dotfiles updater to keep your neovim config up to date
- **`:Lazy`** - Open the plugin manager to see what plugins we've installed

## 🤯 Advanced Features

### Dealing with LSPs
- **`<Leader>cm`** - Open Mason (add support for new languages)
- **`<Leader>ci`** - Show LSP information for current file

### Using Sessions
- **`<Leader>qs`** - Save your session
- **`<Leader>ql`** - Load your session
- **`<Leader>qd`** - Delete your session

### Personalizing Your Config
This Neovim config is totally hackable! Check out the [neovim-dotfiles-personal.scaffold repo](https://github.com/PayPal-Braintree/neovim-dotfiles-personal.scaffold) to see how you can tweak things to your liking.

## 💡 Learning Tips

1. **Take your time**: Master vim basics and neovim navigation tools like `<Leader>ff` before diving into advanced features
2. **Use the help**: Press just `<Leader>` and explore available shortcuts in the `which-key` popup
3. **Don't memorize everything**: Focus on the shortcuts you find most useful for your workflow
4. **Gradually add more**: When you find yourself wanting to get around more efficiently, visit the [CHEATSHEET](../CHEATSHEET.md) to add new shortcuts to your repertoire
5. **Read the Neovim config**: Visit your local configuration at `~/.config/nvim` and take a look around to see how it works!

## 🚀An Example Workflow

1. **Find a file**: `<Leader>ff` → type filename
2. **Understand the code**: Use `gd` to jump to definitions, `K` for documentation
3. **Make your changes**: Use `<Leader>cc` for comments, `<Leader>ca` for quick fixes
4. **Test your work**: `<Leader>rf` to run tests
5. **Clean up**: `<Leader>cf` to format, `<Leader>cw` to clean whitespace

## 🆘 When You're Stuck

- **Forgot a shortcut?** Press `<Leader>` (space) and browse the menu or search for it with `<Leader>sk`
- **Code not working?** Use `[d` / `]d` to jump between errors, then `<Leader>ca` for fixes
- **Can't find something?** Try `<Leader>fg` to search for text
- **Lost in the code?** Use `<Leader>nf` to see where you are in the file tree

Remember: Everyone starts as a beginner! These shortcuts will feel awkward at first, but soon they'll become automatic. Give yourself a week of practice, and you'll be amazed at how much faster you code.
