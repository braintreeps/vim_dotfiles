# classpath.vim

This plugin sets the `'path'` for JVM languages to match the class path of
your current Java project.  This lets commands like `:find` and `gf` work as
designed.  I originally wrote it for Clojure, but I see no reason why it
wouldn't be handy for other languages as well.

Currently, [Maven][] and [Leiningen][] are supported, with a fallback to
`$CLASSPATH` if neither applies.  [Open an issue][GitHub issues] if you have
ideas for supporting another project management system.

Included is a `:Java` command, which executes `java` (or `$JAVA_CMD`) with the
current buffer's `'path'` as the class path.

[Maven]: http://maven.apache.org/
[Leiningen]: https://github.com/technomancy/leiningen
[GitHub issues]: https://github.com/tpope/vim-classpath/issues

## Installation

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/tpope/vim-classpath.git

Once help tags have been generated, you can view the manual with
`:help classpath`.

## FAQ

> Why does it take so long for Vim to startup?

The short answer is because the JVM is slow.

The first time you load a Clojure file from any given project, classpath.vim
sets about trying to determine your class path, leveraging either
`lein classpath` or `mvn dependency:build-classpath`.  This takes a couple of
seconds or so in the best case scenario, and potentially much longer if it
decides to hit the network.

Because the class path is oh-so-expensive to retrieve, classpath.vim caches it
in `~/.cache/vim/classpath`.  The cache is expired when the timestamp on
`project.clj` or `pom.xml` changes.

## Contributing

See the contribution guidelines for
[pathogen.vim](https://github.com/tpope/vim-pathogen#readme).

## Self-Promotion

Like classpath.vim?  Follow the repository on
[GitHub](https://github.com/tpope/vim-classpath).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
