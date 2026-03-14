# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal macOS dotfiles. All configs live under `.config/` (XDG-style) or directly in the repo root. Files are symlinked into `$HOME` — there is no install script; linking is done manually or via GNU Stow.

Consistent theme across all tools: **Catppuccin Mocha**.

## Structure

```
dotfiles/
├── .zshrc / .zsh_aliases       # Zsh shell config
├── starship.toml               # Starship prompt
├── .config/
│   ├── nvim/                   # Neovim (LazyVim-based)
│   ├── tmux/                   # tmux + TPM plugins
│   ├── ghostty/                # Ghostty terminal
│   ├── aerospace/              # AeroSpace tiling WM
│   └── atuin/                  # Shell history
└── .claude/                    # Claude Code settings
```

## Neovim Architecture

Built on [LazyVim](https://www.lazyvim.org/). Entry point: `nvim/init.lua` → `lua/config/lazy.lua`.

- `lua/config/` — options, keymaps, autocmds (extend LazyVim defaults; currently minimal customization)
- `lua/plugins/` — plugin overrides and additions loaded via `{ import = "plugins" }` in `lazy.lua`

Custom plugins added on top of LazyVim:
- `catppuccin.lua` — forces Mocha flavour; patches bufferline integration
- `lazy_vim.lua` — sets catppuccin as LazyVim colorscheme
- `nvim_metals.lua` — Scala LSP (Metals) with DAP; activates on `ft = { "scala", "sbt", "java" }`
- `nvim_dap.lua` — DAP config for Scala, wired to nvim-metals on port 5005

Leader key: `,`

To add a new plugin: create a new file in `nvim/lua/plugins/` returning a lazy.nvim spec table.

## Tmux Architecture

Two-file split:
- `tmux.reset.conf` — all explicit key bindings (vi-style pane navigation, splits, etc.)
- `tmux.conf` — sources reset file first, then sets options and plugin config

Plugin manager: TPM (runs at end of `tmux.conf`). Plugins are gitignored (`.config/tmux/plugins`).

Key custom bindings (prefix = `C-b` / `C-s`):
- `prefix + o` — sessionx (fzf session manager)
- `prefix + p` — floax (floating terminal)
- `prefix + R` — reload config

## Zsh Architecture

`.zshrc` loads in order:
1. zinit (auto-installs if missing) + plugins
2. History / completion settings
3. PATH setup (Homebrew detection for Apple Silicon / Intel / Linux)
4. Tool evals: atuin, zoxide, starship
5. Local overrides (`~/.zshrc.local`, gitignored via `*.local.*`)
6. `.zsh_aliases`

## Ignored / Local Overrides

Files intentionally excluded from git:
- `*.local.*` / `.zshrc.local` — machine-specific overrides
- `.gitconfig.local` — local git identity
- `.config/nvim/lazy-lock.json` — plugin lockfile
- `.config/tmux/plugins/` — TPM-managed plugins
- `.claude/*` except `settings.json` and `claude-powerline.json`
