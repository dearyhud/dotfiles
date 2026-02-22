# ============================================================
#  dotfiles — Bootstrap Makefile
#
#  Usage:
#    make setup         — Install all apps, fonts, colors, plugins, symlinks
#    make install       — Symlinks + plugins (assumes deps already present)
#    make link          — Symlink dotfiles only
#    make unlink        — Remove symlinks
#    make brew          — Install Homebrew dependencies (incl. vim, tmux)
#    make vim-plug      — Install vim-plug + vim plugins
#    make tpm           — Install tmux plugin manager (tpm)
#    make fonts         — Install all Nerd Fonts
#    make colors        — Install rose-pine palettes (iterm2 + terminal)
#    make iterm2        — Install iTerm2
# ============================================================

DOTFILES_DIR := $(shell pwd)
HOME_DIR     := $(HOME)

# CLI tools & apps
BREW_PACKAGES  := vim tmux fzf ripgrep bat fd reattach-to-user-namespace
BREW_CASKS     := iterm2

# Nerd Fonts (all variants in the JetBrainsMono family + extras)
NERD_FONT_CASKS := \
  font-jetbrains-mono-nerd-font \
  font-fira-code-nerd-font \
  font-hack-nerd-font \
  font-meslo-lg-nerd-font

# Rose Pine iTerm2 color preset source
ROSE_PINE_ITERM_URL  := https://raw.githubusercontent.com/rose-pine/iterm/main/dist/rose-pine.itermcolors
ROSE_PINE_MOON_URL   := https://raw.githubusercontent.com/rose-pine/iterm/main/dist/rose-pine-moon.itermcolors
ROSE_PINE_DAWN_URL   := https://raw.githubusercontent.com/rose-pine/iterm/main/dist/rose-pine-dawn.itermcolors
COLORS_DIR           := $(HOME_DIR)/Library/Application\ Support/iTerm2/ColorPresets

.PHONY: setup install link unlink brew vim-plug tpm fonts colors iterm2

# ─── Full machine bootstrap ──────────────────────────────────
setup: brew iterm2 fonts colors vim-plug tpm link
	@echo ""
	@echo "Setup complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Open iTerm2 and set font:   Preferences → Profiles → Text → JetBrainsMono Nerd Font"
	@echo "  2. Apply rose-pine color preset: Preferences → Profiles → Colors → Color Presets → rose-pine-moon"
	@echo "  3. Start tmux and press Ctrl-f I to install tmux plugins"
	@echo "  4. Open vim — plugins install automatically on first launch"

# ─── Install + link (assumes brew deps present) ──────────────
install: vim-plug tpm link
	@echo "Install complete. Run 'make setup' on a fresh machine."

# ─── Symlinks ────────────────────────────────────────────────
link:
	@echo "→ Linking dotfiles..."
	ln -sf $(DOTFILES_DIR)/.vimrc        $(HOME_DIR)/.vimrc
	ln -sf $(DOTFILES_DIR)/.tmux.conf    $(HOME_DIR)/.tmux.conf
	@echo "→ Dotfiles linked."

unlink:
	@echo "→ Removing dotfile symlinks..."
	rm -f $(HOME_DIR)/.vimrc
	rm -f $(HOME_DIR)/.tmux.conf
	@echo "→ Symlinks removed."

# ─── Homebrew + core packages ────────────────────────────────
brew:
	@echo "→ Installing Homebrew packages..."
	@if ! command -v brew >/dev/null 2>&1; then \
	  echo "  Homebrew not found — installing..."; \
	  /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	brew install $(BREW_PACKAGES)

# ─── iTerm2 ──────────────────────────────────────────────────
iterm2:
	@echo "→ Installing iTerm2..."
	brew install --cask iterm2
	@echo "→ iTerm2 installed."

# ─── Nerd Fonts ──────────────────────────────────────────────
fonts:
	@echo "→ Installing Nerd Fonts..."
	brew tap homebrew/cask-fonts 2>/dev/null || true
	brew install --cask $(NERD_FONT_CASKS)
	@echo "→ Fonts installed."
	@echo "  Recommended: JetBrainsMono Nerd Font (matches rose-pine + Powerline)"

# ─── Rose Pine color palettes ────────────────────────────────
colors:
	@echo "→ Installing rose-pine color palettes..."
	@mkdir -p $(COLORS_DIR)
	curl -fsSL $(ROSE_PINE_ITERM_URL)  -o $(COLORS_DIR)/rose-pine.itermcolors
	curl -fsSL $(ROSE_PINE_MOON_URL)   -o $(COLORS_DIR)/rose-pine-moon.itermcolors
	curl -fsSL $(ROSE_PINE_DAWN_URL)   -o $(COLORS_DIR)/rose-pine-dawn.itermcolors
	@echo "→ Rose Pine palettes saved to ~/Library/Application Support/iTerm2/ColorPresets"
	@echo "  In iTerm2: Preferences → Profiles → Colors → Color Presets → rose-pine-moon"

# ─── Vim-plug + plugins ──────────────────────────────────────
vim-plug:
	@echo "→ Installing vim-plug..."
	@if [ ! -f $(HOME_DIR)/.vim/autoload/plug.vim ]; then \
	  curl -fLo $(HOME_DIR)/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
	else \
	  echo "  vim-plug already installed, skipping."; \
	fi
	@echo "→ Installing vim plugins (headless)..."
	vim -E -s -u $(HOME_DIR)/.vimrc +PlugInstall +qall || true
	@echo "→ Vim plugins installed."

# ─── TPM (Tmux Plugin Manager) + tmux-powerline ──────────────
tpm:
	@echo "→ Installing tpm..."
	@if [ ! -d $(HOME_DIR)/.tmux/plugins/tpm ]; then \
	  git clone https://github.com/tmux-plugins/tpm $(HOME_DIR)/.tmux/plugins/tpm; \
	else \
	  echo "  tpm already installed, skipping."; \
	fi
	@echo "→ Installing tmux-powerline..."
	@if [ ! -d $(HOME_DIR)/.tmux/plugins/tmux-powerline ]; then \
	  git clone https://github.com/erikw/tmux-powerline.git $(HOME_DIR)/.tmux/plugins/tmux-powerline; \
	else \
	  echo "  tmux-powerline already installed, skipping."; \
	fi
	@echo "→ tpm + tmux-powerline installed."
	@echo "  Inside tmux press Ctrl-f I to activate all plugins."
