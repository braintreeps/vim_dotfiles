WHAT?

- Run the test/spec your cursor is currently on
- Run the context your cursor is currently in
- Run the entire test/spec you are working in
- Streaming output to a new buffer

This plugin currently supports
  - test/unit
  - dust
  - rspec
  - shoulda

HOW?

Use any of the commands below. Map them to shortcuts
in your .vimrc for easy access.

- commands
  - RunRubyFocusedUnitTest - run focused test/spec
  - RunRubyFocusedContext - run current context (rspec, shoulda)
  - RunAllRubyTests - run all the tests/specs in the current file
  - RunLastRubyTest - run last command again. this means you don't have to
    return to your spec/test file to run the last spec/test again.

INSTALL

Just copy plugin/ruby_focused_unit_test.vim into ~/.vim/plugin. That's it!

REQUIREMENTS

- vim with ruby support (compiled +ruby)

