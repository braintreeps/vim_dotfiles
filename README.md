# neovim-dotfiles

This is fork of the Braintree [vim_dotfiles][vim_dotfiles] repository, configured specifically for Neovim.

## 🔍 Main differences

- 💤 Use [`lazy.nvim`][lazy.nvim] for managing plugins, and lazy-loading them.
- 🔏 `Lockfile` for plugins to ensure compatibility.
- 🆕 Use modern, maintained Neovim-variants of traditional Vim plugins.
- 💻 Leverage advanced tooling, such as LSPs, Treesitter and many more things!

## 🤩 Installing

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

### Running alongside existing Neovim config

If you have a current Neovim configuration that you use and want to test this one out, you can bootstrap the dotfiles as follows:

1. Clone the repo to a different directory (e.g. `~/.config/btnvim`):

```sh
git clone https://github.com/PayPal-Braintree/neovim-dotfiles ~/.config/btnvim
```

2. Tell Neovim to use your custom folder for dotfiles:

```sh
NVIM_APPNAME=btnvim nvim
```

This leverages [Neovim's ability to use different configurations based on XDG environment variables](https://github.com/neovim/neovim/pull/22128).

## 🤝 Contributing

- [GitHub issues](https://github.com/PayPal-Braintree/neovim-dotfiles/issues)
    - Please create for any unexpected behavior, missing behavior, desired improvements, etc. This will help
    ensure that we can successfully "upgrade" our [vim_dotfiles][vim_dotfiles] to Neovim.
- Pull requests are encouraged!

[vim_dotfiles]: https://github.com/braintreeps/vim_dotfiles
[lazy.nvim]: https://github.com/folke/lazy.nvim
