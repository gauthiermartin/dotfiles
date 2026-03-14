# dotfiles

My personal macOS dotfiles. Theme: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) throughout.

## Contents

| Config | Tool | Description |
|--------|------|-------------|
| `.zshrc` / `.zsh_aliases` | [Zsh](https://www.zsh.org/) | Shell config with [zinit](https://github.com/zdharma-continuum/zinit) plugin manager |
| `starship.toml` | [Starship](https://starship.rs/) | Minimal prompt — directory + git status |
| `.config/nvim/` | [Neovim](https://neovim.io/) | [LazyVim](https://www.lazyvim.org/)-based config with Scala/DAP support |
| `.config/tmux/` | [tmux](https://github.com/tmux/tmux) | Terminal multiplexer with TPM plugins |
| `.config/ghostty/` | [Ghostty](https://ghostty.org/) | Terminal emulator |
| `.config/aerospace/` | [AeroSpace](https://github.com/nikitabobko/AeroSpace) | i3-like tiling window manager for macOS |
| `.config/atuin/` | [Atuin](https://atuin.sh/) | Shell history with sync |

## Shell (Zsh)

Plugins via zinit:
- `zsh-autosuggestions` — inline suggestions
- `zsh-syntax-highlighting` — syntax coloring
- `zsh-completions` — extra completions
- `zsh-history-substring-search` — `^P`/`^N` history search

Tool integrations: [Atuin](https://atuin.sh/), [Zoxide](https://github.com/ajeetdsouza/zoxide), [Starship](https://starship.rs/)

## Neovim

LazyVim base with added plugins:
- `nvim-metals` — Scala LSP (Metals) with DAP integration
- `catppuccin` — Mocha colorscheme

## Tmux

Plugins (via TPM):
- `catppuccin/tmux` — Mocha theme, rounded window style
- `tmux-resurrect` + `tmux-continuum` — session persistence
- `tmux-sessionx` — fzf session manager (`prefix + o`)
- `tmux-floax` — floating terminal pane (`prefix + p`)
- `tmux-fzf-url` — open URLs from terminal output

## AeroSpace

i3-inspired tiling WM. Key bindings use `alt` for focus/move/layout and `ctrl` for workspaces 1–10.

## Installation

These dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/) or symlinked manually. No automated install script is included.

```sh
git clone https://github.com/<user>/dotfiles ~/dotfiles
# Symlink individual files as needed, e.g.:
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
```

### Prerequisites (macOS)

```sh
brew install neovim tmux ghostty starship atuin zoxide eza zinit
brew install --cask aerospace
```
