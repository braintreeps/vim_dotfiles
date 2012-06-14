WHAT?
====================

- Run the test/spec your cursor is currently on
- Run the context your cursor is currently in
- Run the entire test/spec you are working in
- Streaming output to tmux via vimux

This plugin currently supports
  - test/unit
  - dust
  - rspec
  - shoulda

HOW?
====================

Use any of the commands below. Map them to shortcuts
in your .vimrc for easy access.

  - RunRubyFocusedTest - run focused test/spec
  - RunRubyFocusedContext - run current context (rspec, shoulda)
  - RunAllRubyTests - run all the tests/specs in the current file

INSTALL
====================

Put the contents of this directory into your pathogen bundle. That's it!

REQUIREMENTS
====================

- vim with ruby support (compiled +ruby)
- [vimux](https://github.com/benmills/vimux)

CONTRIBUTORS:
====================

- [Drew Olson](https://github.com/drewolson)
- [Paul Gross](https://github.com/pgr0ss)
