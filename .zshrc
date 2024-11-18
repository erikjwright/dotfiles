# export CLICOLOR=1
# export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

alias l="eza -la"
alias ls="eza"
alias cd="z"

plugins=(direnv zsh-autosuggestions zsh-history-substring-search)

autoload -Uz compinit && compinit
autoload predict-on

setopt NO_BEEP

# homebrew
PATH="/opt/homebrew/bin/direnv:$PATH"
export EDITOR="/opt/homebrew/bin/nvim"

# wezterm cli
WEZTERM_PATH="/Applications/WezTerm.app/Contents/MacOS"
export PATH="$WEZTERM_PATH:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun completions
[ -s "/Users/erik/.bun/_bun" ] && source "/Users/erik/.bun/_bun"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="/Users/erik/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export STARSHIP_CONFIG=~/.config/starship/starship.toml

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

. "$HOME/.cargo/env"
. <(fzf --zsh)

alias config='/usr/bin/git --git-dir=/Users/erik/.cfg/ --work-tree=/Users/erik'
