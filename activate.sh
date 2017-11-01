#!/bin/bash

set -euo pipefail

dotfiles_dir=$(cd "$(dirname "$0")"; pwd)

if ! vim --version | grep -q '2nd user vimrc file'; then
  for name in vim vimrc vimrc.bundles; do
    rm -rf "${HOME}/.${name}"
    ln -s "${dotfiles_dir}/${name}" "${HOME}/.${name}"
  done
fi

vim +PlugInstall +PlugClean! +qall
