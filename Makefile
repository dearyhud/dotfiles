# ============================================================
#  dotfiles — Bootstrap Makefile
#
#  Usage:
#    make setup         — Full bootstrap (homebrew first, then everything)
#    make install       — Symlinks + plugins (assumes deps already present)
#    make link          — Symlink dotfiles only
#    make unlink        — Remove symlinks
#    make homebrew      — Install Homebrew itself (run this first on fresh machine)
#    make brew          — Install Homebrew CLI packages (vim, tmux, etc.)
#    make rvm           — Install RVM + latest stable Ruby
#    make docker        — Install Docker Desktop
#    make iterm2        — Install iTerm2
#    make vim-plug      — Install vim-plug + vim plugins
#    make tpm           — Install tmux plugin manager + tmux-powerline
#    make fonts         — Install all Nerd Fonts
#    make colors        — Install rose-pine palettes for iTerm2
# ============================================================

DOTFILES_DIR := $(shell pwd)
HOME_DIR     := $(HOME)

# CLI tools
BREW_PACKAGES := vim tmux fzf ripgrep bat fd reattach-to-user-namespace

# Nerd Fonts
NERD_FONT_CASKS := \
  font-jetbrains-mono-nerd-font \
  font-fira-code-nerd-font \
  font-hack-nerd-font \
  font-meslo-lg-nerd-font

# Rose Pine iTerm2 color presets
ROSE_PINE_ITERM_URL := https://raw.githubusercontent.com/rose-pine/iterm/main/dist/rose-pine.itermcolors
ROSE_PINE_MOON_URL  := https://raw.githubusercontent.com/rose-pine/iterm/main/dist/rose-pine-moon.itermcolors
ROSE_PINE_DAWN_URL  := https://raw.githubusercontent.com/rose-pine/iterm/main/dist/rose-pine-dawn.itermcolors
COLORS_DIR          := $(HOME_DIR)/Library/Application\ Support/iTerm2/ColorPresets

.PHONY: setup install link unlink homebrew brew rvm docker iterm2 vim-plug tpm fonts colors

# ─── Full machine bootstrap ──────────────────────────────────
# homebrew must run first — everything else depends on it
setup: homebrew brew rvm docker iterm2 fonts colors vim-plug tpm link
	@echo ""
	@echo "Bootstrap complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Open iTerm2 → Preferences → Profiles → Text → JetBrainsMono Nerd Font"
	@echo "  2. Open iTerm2 → Preferences → Profiles → Colors → Color Presets → rose-pine-moon"
	@echo "  3. Start tmux and press Ctrl-f I to install tmux plugins"
	@echo "  4. Open vim — plugins install automatically on first launch"
	@echo "  5. Open Docker Desktop and complete the first-run setup"

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

# ─── Homebrew (prerequisite for everything else) ─────────────
homebrew:
	@echo "→ Checking for Homebrew..."
	@if ! command -v brew >/dev/null 2>&1; then \
	  echo "  Homebrew not found — installing..."; \
	  /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	  echo "  Homebrew installed."; \
	  if [ -f /opt/homebrew/bin/brew ]; then \
	    eval "$$(/opt/homebrew/bin/brew shellenv)"; \
	  fi; \
	else \
	  echo "  Homebrew already installed, skipping."; \
	fi

# ─── Homebrew CLI packages ───────────────────────────────────
brew: homebrew
	@echo "→ Installing Homebrew packages..."
	brew install $(BREW_PACKAGES)
	@echo "→ Homebrew packages installed."

# ─── RVM + Ruby ──────────────────────────────────────────────
rvm:
	@echo "→ Installing RVM..."
	@if ! command -v rvm >/dev/null 2>&1 && [ ! -s "$(HOME_DIR)/.rvm/scripts/rvm" ]; then \
	  curl -sSL https://get.rvm.io | bash -s stable --ruby; \
	else \
	  echo "  RVM already installed, skipping."; \
	fi
	@echo "→ RVM installed."
	@echo "  Run: source ~/.rvm/scripts/rvm   (or open a new shell)"
	@echo "  Then: rvm use ruby --default"

# ─── Docker Desktop ──────────────────────────────────────────
docker:
	@echo "→ Installing Docker Desktop..."
	@if ! [ -d "/Applications/Docker.app" ]; then \
	  brew install --cask docker; \
	  echo "→ Docker Desktop installed."; \
	  echo "  Open Docker Desktop from Applications to complete first-run setup."; \
	else \
	  echo "  Docker Desktop already installed, skipping."; \
	fi

# ─── iTerm2 ──────────────────────────────────────────────────
iterm2:
	@echo "→ Installing iTerm2..."
	@if ! [ -d "/Applications/iTerm.app" ]; then \
	  brew install --cask iterm2; \
	  echo "→ iTerm2 installed."; \
	else \
	  echo "  iTerm2 already installed, skipping."; \
	fi

# ─── Nerd Fonts ──────────────────────────────────────────────
fonts:
	@echo "→ Installing Nerd Fonts..."
	brew install --cask $(NERD_FONT_CASKS)
	@echo "→ Fonts installed."
	@echo "  Recommended: JetBrainsMono Nerd Font (rose-pine + Powerline)"

# ─── Rose Pine color palettes ────────────────────────────────
colors:
	@echo "→ Installing rose-pine color palettes..."
	@mkdir -p $(COLORS_DIR)
	curl -fsSL $(ROSE_PINE_ITERM_URL) -o $(COLORS_DIR)/rose-pine.itermcolors
	curl -fsSL $(ROSE_PINE_MOON_URL)  -o $(COLORS_DIR)/rose-pine-moon.itermcolors
	curl -fsSL $(ROSE_PINE_DAWN_URL)  -o $(COLORS_DIR)/rose-pine-dawn.itermcolors
	@echo "→ Rose Pine palettes saved to ~/Library/Application Support/iTerm2/ColorPresets"
	@echo "  iTerm2 → Preferences → Profiles → Colors → Color Presets → rose-pine-moon"

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
