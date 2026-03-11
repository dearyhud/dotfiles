# zsh-completions
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
  autoload -Uz compinit
  compinit
fi

# zsh-autosuggestions
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

export PATH="$PATH:/Users/dearyhudsoniii/sites/backpack/backpack-backend/infra/scripts/aws-session-token.sh"

alias bp_commit='npm run prettier:fix && git add . && git commit -m'
alias git_pristine='git branch | ag -v "main" | xargs git branch -D'
alias mono_pr_diffs="sh ~/sites/commits.sh"
alias vf='vim $(fzf)'

alias new_session_token='sh ~/sites/backpack/backpack-infra/scripts/aws-session-token.sh deary $(op item get "AWS|Backpack" --otp)'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="$HOME/bin:$PATH"

# Added by Antigravity
export PATH="/Users/dearyhudsoniii/.antigravity/antigravity/bin:$PATH"

start_ui() {
  # Usage:
  #   start_ui            # main flow: checkout main, pull origin main
  #   start_ui eng-2810   # branch flow: local or remote branch, pull only if upstream exists

  cd ~/sites/backpack/backpack-frontend/web-app || { echo "Directory not found!"; return 1; }

  # Use correct node version via nvm
  echo "Setting node version..."
  if ! nvm use; then
    echo "Node version not found. Attempting to install..."
    nvm install && nvm use || { echo "Failed to install/use node"; return 1; }
  else
    echo "Node version set successfully."
  fi

  # Detect origin
  local HAS_ORIGIN=false
  if git remote get-url origin >/dev/null 2>&1; then
    HAS_ORIGIN=true
  fi

  # ----------------------------
  # No branch provided: main flow
  # ----------------------------
  if [ -z "$1" ]; then
    echo "No branch provided. Using main."

    echo "Checking out main..."
    git checkout main || { echo "Failed to checkout main."; return 1; }

    if [ "$HAS_ORIGIN" = true ]; then
      echo "Pulling latest changes from origin/main..."
      git pull origin main || { echo "Failed to pull origin/main."; return 1; }
    else
      echo "No origin remote found. Skipping pull."
    fi

    echo "Installing dependencies..."
    yarn install || { echo "Failed to install dependencies"; return 1; }

    echo "Starting the app..."
    yarn start
    return 0
  fi

  # -----------------------------------
  # Branch provided: branch-aware flow
  # -----------------------------------
  local BRANCH="$1"
  echo "Branch provided: $BRANCH"

  if [ "$HAS_ORIGIN" = true ]; then
    echo "Origin detected. Fetching latest branches..."
    git fetch -q origin --prune || { echo "Failed to fetch from origin."; return 1; }
  else
    echo "No origin remote found. Using local branches only."
  fi

  echo "Checking out branch: $BRANCH"

  # Local branch exists → checkout
  if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git checkout "$BRANCH" || { echo "Failed to checkout local branch $BRANCH."; return 1; }

  # Remote branch exists → create local tracking branch
  elif [ "$HAS_ORIGIN" = true ] && git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
    git checkout -b "$BRANCH" --track "origin/$BRANCH" || {
      echo "Failed to checkout remote branch origin/$BRANCH."
      return 1
    }

  else
    echo "Branch '$BRANCH' not found locally$( [ "$HAS_ORIGIN" = true ] && echo " or on origin" )."
    echo "Try: git branch -a | grep -i '$BRANCH'"
    return 1
  fi

  # Pull ONLY if upstream exists (prevents failing on local-only branches)
  local UPSTREAM
  UPSTREAM="$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)"

  if [ -n "$UPSTREAM" ]; then
    echo "Pulling latest changes from upstream ($UPSTREAM)..."
    git pull --ff-only || { echo "Failed to pull latest changes."; return 1; }
  else
    echo "No upstream configured for '$BRANCH'. Skipping pull."
    echo "If you later push it, you can set upstream with:"
    echo "  git push -u origin $BRANCH"
  fi

  echo "Installing dependencies..."
  yarn install || { echo "Failed to install dependencies"; return 1; }

  echo "Starting the app..."
  yarn start
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Custom
autoload -Uz vcs_info
precmd() { vcs_info }

setopt prompt_subst
zstyle ':vcs_info:git:*' formats '(%b)'

# PROMPT='%~ ${vcs_info_msg_0_} % '
# PROMPT='%~${vcs_info_msg_0_:+ ${vcs_info_msg_0_}} % $ '
PROMPT='%~ % $ '


# Environment Variables

printf '\033]2;%s\033\\' "$(ipconfig getifaddr en0)"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/dearyhudsoniii/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
