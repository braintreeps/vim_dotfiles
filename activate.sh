#!/bin/bash

set -e

dotfiles_dir=$(cd "$(dirname "$0")"; pwd)

ln -s --backup -T ${dotfiles_dir}/vim ~/.vim
ln -s --backup ${dotfiles_dir}/vimrc ~/.vimrc
ln -s --backup ${dotfiles_dir}/gvimrc ~/.gvimrc
ln -s --backup ${dotfiles_dir}/vimrc.bundles ~/.vimrc.bundles

vim +PlugInstall +PlugClean! +GoInstallBinaries +qall
