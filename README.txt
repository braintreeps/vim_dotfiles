After cloning this project, you can run the following to link these dotfiles
into your home directory:

    rake

Be warned: this will overwrite any existing .vimrc, .gvimrc or .vim/ files you
have in your home directory.

Uses `vim-plug` to manage bundles. Downloading and setting up the described
plugins requires an extra step:

    vim +:PlugInstall

If you plan on using command-t, you'll need to build the C extension. Vim-plug
will do this automatically, but if it fails for some reason, you can do it
manually, however make sure to use the ruby you built vim against:

    cd ~/.vim/plugged/command-t/ruby/command-t
    rvm use system
    ruby extconf.rb
    make
