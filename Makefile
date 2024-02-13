stow_dirs := $(wildcard */)

.PHONY: *

install:
	stow --target $(HOME) $(stow_dirs)

uninstall:
	stow --target $(HOME) -D $(stow_dirs)
