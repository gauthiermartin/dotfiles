.DEFAULT_GOAL := help
SHELL         := /bin/bash

DOTFILES := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# ── Homebrew dependencies ──────────────────────────────────────────────────
FORMULAE := neovim tmux starship atuin zoxide eza fzf ripgrep fd node pre-commit
CASKS    := aerospace ghostty

# ── Symlink map: "repo_path:home_path" ────────────────────────────────────
# Each entry is split on the first colon: left = repo-relative, right = $HOME target
LINKS := \
	.zshrc:$(HOME)/.zshrc \
	.zsh_aliases:$(HOME)/.zsh_aliases \
	starship.toml:$(HOME)/.config/starship.toml \
	.config/nvim:$(HOME)/.config/nvim \
	.config/tmux:$(HOME)/.config/tmux \
	.config/ghostty:$(HOME)/.config/ghostty \
	.config/aerospace:$(HOME)/.config/aerospace \
	.config/atuin:$(HOME)/.config/atuin \
	.claude/settings.json:$(HOME)/.claude/settings.json

# ── Colors ─────────────────────────────────────────────────────────────────
BOLD   := \033[1m
GREEN  := \033[0;32m
CYAN   := \033[0;36m
YELLOW := \033[0;33m
RED    := \033[0;31m
RESET  := \033[0m

# ── Helpers ─────────────────────────────────────────────────────────────────
define link_file
	src="$(DOTFILES)/$(1)"; \
	dst="$(2)"; \
	mkdir -p "$$(dirname "$$dst")"; \
	if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
		printf "  $(GREEN)✓$(RESET) $$dst $(CYAN)(already linked)$(RESET)\n"; \
	elif [ -e "$$dst" ] || [ -L "$$dst" ]; then \
		printf "  $(YELLOW)~$(RESET) backing up $$dst → $$dst.bak\n"; \
		mv "$$dst" "$$dst.bak"; \
		ln -sf "$$src" "$$dst"; \
		printf "  $(GREEN)✓$(RESET) $$dst\n"; \
	else \
		ln -sf "$$src" "$$dst"; \
		printf "  $(GREEN)✓$(RESET) $$dst\n"; \
	fi
endef

.PHONY: help install brew link tpm update unlink status

# ── Targets ─────────────────────────────────────────────────────────────────

## help          Show this help message
help:
	@printf "$(BOLD)dotfiles$(RESET) — macOS setup & sync\n\n"
	@printf "$(CYAN)Usage:$(RESET) make <target>\n\n"
	@printf "$(CYAN)Targets:$(RESET)\n"
	@awk '/^## /{printf "  $(GREEN)%-16s$(RESET)%s\n", $$2, substr($$0, index($$0,$$3))}' $(MAKEFILE_LIST)
	@printf "\n$(CYAN)Typical first-time setup:$(RESET)\n"
	@printf "  make install\n"
	@printf "\n$(CYAN)Keep repo in sync with live edits:$(RESET)\n"
	@printf "  make update && git diff\n"

## install       Full setup: brew + link + tpm + pre-commit hooks
install: brew link tpm
	@pre-commit install --install-hooks
	@printf "\n$(GREEN)$(BOLD)✓ Install complete$(RESET)\n"
	@printf "$(YELLOW)→$(RESET) Open a new shell to apply zsh changes\n"
	@printf "$(YELLOW)→$(RESET) First tmux session: press $(BOLD)prefix + I$(RESET) to install plugins\n"
	@printf "$(YELLOW)→$(RESET) First nvim launch: lazy.nvim will auto-install plugins\n"

## brew          Install / update all Homebrew formulae and casks
brew:
	@command -v brew &>/dev/null || { \
		printf "$(CYAN)→$(RESET) Installing Homebrew...\n"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	}
	@printf "$(CYAN)→$(RESET) Formulae:\n"
	@for pkg in $(FORMULAE); do \
		if brew list --formula "$$pkg" &>/dev/null; then \
			printf "  $(GREEN)✓$(RESET) $$pkg\n"; \
		else \
			printf "  $(CYAN)+$(RESET) installing $$pkg...\n"; \
			brew install "$$pkg"; \
		fi; \
	done
	@printf "$(CYAN)→$(RESET) Casks:\n"
	@for cask in $(CASKS); do \
		if brew list --cask "$$cask" &>/dev/null; then \
			printf "  $(GREEN)✓$(RESET) $$cask\n"; \
		else \
			printf "  $(CYAN)+$(RESET) installing $$cask...\n"; \
			brew install --cask "$$cask"; \
		fi; \
	done

## link          Symlink all dotfiles into $$HOME (backs up existing files)
link:
	@mkdir -p $(HOME)/.config $(HOME)/.claude
	@printf "$(CYAN)→$(RESET) Creating symlinks...\n"
	@ts=$$(date +%Y%m%d_%H%M%S); \
	for pair in $(LINKS); do \
		src="$(DOTFILES)/$${pair%%:*}"; \
		dst="$${pair##*:}"; \
		mkdir -p "$$(dirname "$$dst")"; \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			printf "  $(GREEN)✓$(RESET) $$dst $(CYAN)(already linked)$(RESET)\n"; \
		elif [ -e "$$dst" ] || [ -L "$$dst" ]; then \
			bak="$$dst.bak.$$ts"; \
			mv "$$dst" "$$bak"; \
			printf "  $(YELLOW)~$(RESET) backed up → $$(basename $$bak)\n"; \
			ln -sf "$$src" "$$dst"; \
			printf "  $(GREEN)✓$(RESET) $$dst\n"; \
		else \
			ln -sf "$$src" "$$dst"; \
			printf "  $(GREEN)✓$(RESET) $$dst\n"; \
		fi; \
	done

## tpm           Clone Tmux Plugin Manager into tmux config dir
tpm:
	@if [ -d "$(HOME)/.config/tmux/plugins/tpm" ]; then \
		printf "$(GREEN)✓$(RESET) TPM already installed\n"; \
	else \
		printf "$(CYAN)→$(RESET) Cloning TPM...\n"; \
		git clone --depth=1 https://github.com/tmux-plugins/tpm \
			"$(HOME)/.config/tmux/plugins/tpm"; \
		printf "$(GREEN)✓$(RESET) TPM installed\n"; \
	fi

## update        Copy live $$HOME config back into repo (for edits made outside repo)
update:
	@printf "$(CYAN)→$(RESET) Syncing live config → repo...\n"
	@changed=0; \
	for pair in $(LINKS); do \
		repo_rel="$${pair%%:*}"; \
		src="$(DOTFILES)/$$repo_rel"; \
		dst="$${pair##*:}"; \
		if [ ! -e "$$dst" ] && [ ! -L "$$dst" ]; then \
			printf "  $(YELLOW)–$(RESET) $$dst not found, skipping\n"; \
		elif [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			printf "  $(GREEN)✓$(RESET) $$repo_rel $(CYAN)(symlinked, nothing to do)$(RESET)\n"; \
		elif [ -d "$$dst" ]; then \
			rsync -a \
				--exclude='plugins/' \
				--exclude='lazy-lock.json' \
				--exclude='*.local.*' \
				"$$dst/" "$$src/"; \
			printf "  $(CYAN)↓$(RESET) $$repo_rel (synced from $$dst)\n"; \
			changed=1; \
		else \
			cp "$$dst" "$$src"; \
			printf "  $(CYAN)↓$(RESET) $$repo_rel (copied from $$dst)\n"; \
			changed=1; \
		fi; \
	done; \
	if [ "$$changed" -eq 1 ]; then \
		printf "\n$(GREEN)✓$(RESET) Sync complete — review with $(BOLD)git diff$(RESET)\n"; \
	else \
		printf "\n$(GREEN)✓$(RESET) Already in sync\n"; \
	fi

## status        Show symlink status for all tracked dotfiles
status:
	@printf "$(BOLD)Symlink status$(RESET)\n\n"
	@for pair in $(LINKS); do \
		repo_rel="$${pair%%:*}"; \
		src="$(DOTFILES)/$$repo_rel"; \
		dst="$${pair##*:}"; \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			printf "  $(GREEN)✓$(RESET) $$dst → $$src\n"; \
		elif [ -L "$$dst" ]; then \
			printf "  $(YELLOW)⚠$(RESET) $$dst → $$(readlink "$$dst") $(RED)(points elsewhere)$(RESET)\n"; \
		elif [ -e "$$dst" ]; then \
			printf "  $(YELLOW)~$(RESET) $$dst $(YELLOW)(exists, not linked)$(RESET)\n"; \
		else \
			printf "  $(RED)✗$(RESET) $$dst $(RED)(missing)$(RESET)\n"; \
		fi; \
	done

## unlink        Remove repo symlinks from $$HOME (leaves backups intact)
unlink:
	@printf "$(YELLOW)→$(RESET) Removing symlinks...\n"
	@for pair in $(LINKS); do \
		dst="$${pair##*:}"; \
		src="$(DOTFILES)/$${pair%%:*}"; \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			rm "$$dst"; \
			printf "  $(RED)✗$(RESET) removed $$dst\n"; \
		else \
			printf "  $(YELLOW)–$(RESET) $$dst (not a repo symlink, skipped)\n"; \
		fi; \
	done
