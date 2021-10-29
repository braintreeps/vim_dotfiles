#!/bin/bash

set -euo pipefail

dotfiles_dir=$(cd "$(dirname "$0")"; pwd)
mkdir -p "${HOME}/.config/nvim" "${HOME}/.config/nvim/lua"

if ! vim --version | grep -q '2nd user vimrc file'; then
  for name in vim vimrc vimrc.bundles; do
    rm -rf "${HOME}/.${name}"
    ln -s "${dotfiles_dir}/${name}" "${HOME}/.${name}"
  done
fi
for name in config/nvim/init.vim config/nvim/lua/lsp_on_attach.lua; do
  rm -rf "${HOME}/.${name}"
  ln -s "${dotfiles_dir}/${name}" "${HOME}/.${name}"
done

vim +PlugInstall +PlugClean! +qall
