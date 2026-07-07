# Makefile — GNU Stow helper for this dotfiles repo.
# Run from the repo root; stow's implicit target dir is $HOME (one level up),
# and .stowrc's --no-folding is picked up automatically for every invocation here.
#
#   make          same as `make help`
#   make stow     stow every package (fresh laptop setup)
#   make unstow   remove every stowed package
#   make restow   restow every package (stow -R)
#   make sync     stow only packages not yet stowed (new pkg dir / git pull)
#   make list     print detected package names
#   make help     show this text

SHELL := /bin/bash

# Every top-level directory is a stow package (see README). wildcard() uses
# glob() semantics, which already excludes dotfiles/dotdirs (.git, .claude,
# .stowrc, .gitignore), so no explicit exclude list is needed today.
PACKAGES := $(patsubst %/,%,$(wildcard */))

.DEFAULT_GOAL := help

.PHONY: help list stow unstow restow sync

help:
	@echo "Packages: $(PACKAGES)"
	@echo ""
	@echo "make stow    - stow every package"
	@echo "make unstow  - unstow (remove) every package"
	@echo "make restow  - restow every package (stow -R)"
	@echo "make sync    - stow only packages not yet stowed"
	@echo "make list    - list detected packages"

list:
	@echo $(PACKAGES)

stow:
	stow $(PACKAGES)

unstow:
	stow -D $(PACKAGES)

restow:
	stow -R $(PACKAGES)

sync:
	@set -e; \
	for pkg in $(PACKAGES); do \
		out=$$(stow -n -v $$pkg 2>&1) || { \
			echo "$$out" >&2; \
			echo "make: '$$pkg' has a conflict, aborting (see stow output above)" >&2; \
			exit 1; \
		}; \
		if echo "$$out" | grep -q '^LINK:'; then \
			echo "stowing:  $$pkg"; \
			stow $$pkg; \
		else \
			echo "skipping: $$pkg (already stowed)"; \
		fi; \
	done
