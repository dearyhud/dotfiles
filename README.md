# dotfiles

Personal dotfiles — bootstraps a local development environment via `make`.

## What's included

| File | Description |
|------|-------------|
| `.vimrc` | Vim config — FZF IDE-style setup, NERDTree, rose-pine moon colorscheme |
| `.tmux.conf` | tmux config — custom prefix (`C-f`), vim-aware pane navigation, tpm |
| `Makefile` | Bootstrap automation |

## Quick start (fresh machine)

```sh
git clone git@github.com:dearyhud/dotfiles.git ~/sites/dotfiles
cd ~/sites/dotfiles
make setup
```

`make setup` runs the full bootstrap in order:

1. **brew** — installs Homebrew (if missing) + `vim`, `tmux`, `fzf`, `ripgrep`, `bat`, `fd`
2. **iterm2** — installs iTerm2 via Homebrew cask
3. **fonts** — installs Nerd Fonts: JetBrainsMono, Fira Code, Hack, MesloLG
4. **colors** — downloads all three rose-pine palettes (main, moon, dawn) into iTerm2
5. **vim-plug** — installs vim-plug and runs `:PlugInstall` headlessly
6. **tpm** — clones tpm + tmux-powerline to `~/.tmux/plugins/`
7. **link** — symlinks `.vimrc` and `.tmux.conf` into `$HOME`

## Individual targets

```sh
make install     # vim-plug + tpm + symlinks only (deps already present)
make link        # Symlink dotfiles only (safe to re-run)
make unlink      # Remove symlinks
make brew        # Homebrew CLI packages only
make iterm2      # iTerm2 only
make fonts       # All Nerd Fonts only
make colors      # rose-pine iTerm2 palettes only
make vim-plug    # vim-plug + plugins only
make tpm         # tpm + tmux-powerline only
```

## Post-install steps

1. **iTerm2 font** — Preferences → Profiles → Text → set font to `JetBrainsMono Nerd Font`
2. **iTerm2 color** — Preferences → Profiles → Colors → Color Presets → `rose-pine-moon`
3. **tmux plugins** — inside a tmux session press `Ctrl-f I` to activate plugins
4. **Vim** — opens with rose-pine moon automatically; plugins installed headlessly by `make setup`

## Vim keybindings (leader = `Space`)

| Key | Action |
|-----|--------|
| `Space f` | Fuzzy find files |
| `Space /` | Search file contents (ripgrep) |
| `Space e` | Toggle NERDTree sidebar |
| `Space b` | Switch buffers |
| `Space h` | File history |

## tmux prefix

Default prefix is remapped to `Ctrl-f`. Pane navigation mirrors Vim splits (`Ctrl-h/j/k/l`).
