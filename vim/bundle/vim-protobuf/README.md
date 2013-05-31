# vim-protobuf

Vim syntax highlighting for Google's Protocol Buffers

## Introduction

This plugin exists for the sole purpose of making it easy to install syntax highlighting for protocol buffer 
as a pathogen bundle. If you are not already using Tim Pope's awesome [Pathogen plugin][vim pathogen] you 
should check it out.

The syntax highlighting code was shamelessly copied from [Google Protocol Buffers v2.4.1][proto syntax]

## Installation

* With [Pathogen][vim pathogen]

        cd ~/.vim/bundle
        git clone git://github.com/uarun/vim-protobuf.git

* With [Vundle][vim vundle]

        " .vimrc
        Bundle 'uarun/vim-protobuf'

[vim pathogen]: http://www.vim.org/scripts/script.php?script_id=2332
[vim vundle]: https://github.com/gmarik/vundle
[proto syntax]: http://protobuf.googlecode.com/svn/tags/2.4.1/editors/proto.vim
