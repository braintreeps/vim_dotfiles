# neovim-dotfiles

This is a copy of the Braintree [vim_dotfiles][vim_dotfiles]
repository, configured for Neovim specifically.

## 🔍 Main differences

- Use [`lazy.nvim`][lazy.nvim] for managing plugins, and lazy-loading them.
- `Lockfile` for plugins to ensure compatibility.
- Use modern, maintained Neovim-variants of traditional Vim plugins.

## 🤩 Installing

The main thing is that `nvim/.config/nvim` should be copied to your `$HOME/.config/nvim` directory
(so that `$HOME/.config/nvim/init.lua` exists).

**Optional:** You can use `Make` to install the dotfiles. We use [`stow`][stow] to symlink them from this
repo to the correct location. If you have `make` and [`stow`][stow] installed, you can run:

```sh
make install
```

## 🤝 Contributing

- GitHub issues
    - Please create for any unexpected behavior, missing behavior, desired improvements, etc. This will help
    ensure that we can successfully "upgrade" our [vim_dotfiles][vim_dotfiles] to Neovim.
- Pull requests are encouraged!

[vim_dotfiles]: https://github.com/braintreeps/vim_dotfiles
[lazy.nvim]: https://github.com/folke/lazy.nvim
[stow]: https://www.gnu.org/software/stow/
