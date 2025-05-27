# neovim-dotfiles

This is fork of the Braintree [vim_dotfiles][vim_dotfiles] repository, configured specifically for Neovim.

## 🔍 Main differences

- 💤 Use [`lazy.nvim`][lazy.nvim] for managing plugins, and lazy-loading them.
- 🔏 `Lockfile` for plugins to ensure compatibility.
- 🆕 Use modern, maintained Neovim-variants of traditional Vim plugins.
- 💻 Leverage advanced tooling, such as LSPs, Treesitter and many more things!

## 🤩 Getting started

Neovim is already installed by default on new cpairs!

To confirm you're ready to get started, try launching neovim with the `nvim` command and pressing the `<Leader>` key (`\` by default).
You should see a small floating window appear in the bottom-right corner of the screen. If you don't see that window pop up, then you'll need to follow the **Installation Guide** below.

If you saw that floating window popup, you already have these `neovim-dotfiles`
installed and ready to go. Let's take a look at some of the cool new features in
our neovim setup!

### 🕵️ `which-key.nvim`

That floating popup you saw when you hit `\` for the first time comes from an
awesome plugin called [`which-key.nvim`][which-key.nvim]. This plugin provides a window of "hints" to
remind you of what keymaps are available within the editor. It's like your new
cheat sheet! Once the window is open, it will automatically update based on any
commands that follow, so you can even use it to see what keymaps are available
directly from normal mode. Try typing `\` (the leader key) and then hit
backspace to see what other keymaps are documented in normal mode.

> [!NOTE]
> Not ALL keymaps will automatically show up in `which-key`, as some are provided
> by legacy vimscript plugins or the C code within the underlying vim implementation.
> Keymaps can be added to `which-key` manually though, so if you notice one you'd like
> to see that's missing, reach out in #bt-neovim-collab to see about getting it added.

### 🔭 `telescope.nvim`

In neovim, we have an awesome picker TUI powered by the plugin [`telescope.nvim`][telescope.nvim].
All the familiar keymaps you've used in vim for fuzzy finding are ported over to
neovim using telescope! Telescope gives us even more cool functionality though.
To see a list of available picker keymaps, take a look at the which-key popup
for the prefixes `\f` ("find" family of keymaps) and `\s` ("search" family of
keymaps). You can even use telescope to search for any keymap configured within
the editor (even those that don't show up in `which-key`) with `\sk`!

> [!TIP]
> If you just searched for something in a telescope picker and would
> like to pull up the same results again, "resume" your search with `\sr`

> [!TIP]
> When fuzzy finding files, it's useful to be able to scope your search to a
> specific directory. You can do this by using the `<C-t>` keymap from inside a
> telescope picker. This will open up a new picker to find the directory you
> want to scope to, and will then resume your prior fuzzy find from there

### ✨ Personalization

While these dotfiles aim to be a complete solution and provide a "lingua franca" for
Braintree developers, one of the coolest advantages of Neovim is its ease of
customization! If you want to change anything about how these base dotfiles behave,
or try out new plugins to optimize your personal workflows, head on over to the
[`neovim-dotfiles-personal.scaffold`][neovim-dotfiles-personal.scaffold] repo to see how to easily integrate your
customizations!

### GitHub Copilot

See [this Confluence](https://paypal.atlassian.net/wiki/spaces/~701219270873f820e4a768dc67670670c499d/pages/2246970746/Getting+started+with+neovim+and+Copilot+at+Braintree) for detailed setup instructions.

#### Authenticate
`:Copilot auth` or `\al`

#### Tab completion
To cycle between tab-completed suggestions, use `C-n` and `C-p` (Vim shorthand
for Control n and Control p).

## ⚙️ Installation Guide

- Back up your current Neovim files (if any):

```sh
mv ~/.config/nvim{,.bak}
```

- Clone the dotfiles

```sh
git clone https://github.com/PayPal-Braintree/neovim-dotfiles ~/.config/nvim
```

- Start Neovim!

```sh
nvim
```

> [!TIP]
> It's recommended to run `:Lazy health` after installation. This will load all plugins, and check if everything is working correctly.

### 👥 Running alongside existing Neovim config

If you have a current Neovim configuration that you use and want to test this one out, you can bootstrap the dotfiles as follows:

1. Clone the repo to a different directory (e.g. `~/.config/btnvim`):

```sh
git clone https://github.com/PayPal-Braintree/neovim-dotfiles ~/.config/btnvim
```

2. Tell Neovim to use your custom folder for dotfiles:

```sh
NVIM_APPNAME=btnvim nvim
```

3. Optionally set up an alias in your `~/.zshrc_personal` for ease of access
```sh
alias bvim="NVIM_APPNAME=btnvim nvim"
```

This leverages [Neovim's ability to use different configurations based on XDG environment variables](https://github.com/neovim/neovim/pull/22128).

## 🤝 Contributing

- [GitHub issues](https://github.com/PayPal-Braintree/neovim-dotfiles/issues)
    - Please create for any unexpected behavior, missing behavior, desired improvements, etc. This will help
    ensure that we can successfully "upgrade" our [vim_dotfiles][vim_dotfiles] to Neovim.
- Pull requests are encouraged!

[vim_dotfiles]: https://github.com/braintreeps/vim_dotfiles
[lazy.nvim]: https://github.com/folke/lazy.nvim
[neovim-dotfiles-personal.scaffold]: https://github.com/PayPal-Braintree/neovim-dotfiles-personal.scaffold
[which-key.nvim]: https://github.com/folke/which-key.nvim
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
