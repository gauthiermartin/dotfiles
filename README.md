# dotfiles

Personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose contents mirror `$HOME`. Running
`stow` for a package symlinks its files into place.

## Packages

| Package    | Manages                                    |
| ---------- | ------------------------------------------- |
| `atuin`    | `~/.config/atuin/config.toml`                |
| `eza`      | `~/.config/eza/theme.yml`                    |
| `ghostty`  | `~/.config/ghostty/config` (+ themes)        |
| `git`      | `~/.gitconfig`                               |
| `herdr`    | `~/.config/herdr/config.toml`                |
| `hunk`     | `~/.config/hunk/config.toml`                 |
| `nvim`     | `~/.config/nvim` (LazyVim-based config)      |
| `starship` | `~/.config/starship.toml`                    |
| `zsh`      | `~/.zshrc`, `~/.zsh_aliases`                 |

## Requirements

- [GNU Stow](https://www.gnu.org/software/stow/): `brew install stow`

A repo-local `.stowrc` sets `--no-folding` as the default for every `stow`
invocation run from this directory. Without it, stow "folds" a package
directory into a single symlink when it only contains stowed files (e.g.
`~/.config/hunk` → the repo directly), so any runtime file an app later
writes there (caches, state, history) ends up physically inside the repo.
`--no-folding` keeps target directories real and only symlinks the
individual tracked files, so runtime files stay local to `$HOME`.

## Usage

Clone this repo to `~/.dotfiles`, then stow the packages you want:

```sh
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles

# Stow everything
stow */

# Or stow individual packages
stow zsh git nvim
```

To remove the symlinks for a package:

```sh
stow -D <package>
```

To re-stow (useful after adding new files to a package):

```sh
stow -R <package>
```

## Adding a new package

Create a directory named after the tool, and inside it recreate the path the
config lives at relative to `$HOME`, e.g. for a tool that reads
`~/.config/foo/config.yml`:

```sh
mkdir -p foo/.config/foo
mv ~/.config/foo/config.yml foo/.config/foo/
stow foo
```
