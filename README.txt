After cloning this project, you can run the following to link these dotfiles
into your home directory:

    ./activate.rb

Be warned: this will overwrite any existing .vimrc, .gvimrc or .vim/ files you
have in your home directory.

If you plan on using command-t, you'll need to build the C extension. Make sure
to use the ruby you built vim against. Here's what I ran:

    cd vim/bundle/command-t/ruby/command-t
    rvm use system
    ruby extconf.rb
    make
