alias l="eza -la"
alias ls="eza"
alias cd="z"

alias config='/usr/bin/git --git-dir=/Users/erik/.cfg/ --work-tree=/Users/erik'

autoload -Uz compinit && compinit
autoload predict-on
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

setopt NO_BEEP

ZVM_CURSOR_STYLE_ENABLED=false

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

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/erik/.cache/lm-studio/bin"

export STARSHIP_CONFIG=~/.config/starship/starship.toml

export ZVM_CURSOR_STYLE_ENABLED=false
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"

eval "$(/opt/homebrew/bin/brew shellenv)"
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

. "$HOME/.cargo/env"
. <(fzf --zsh)
. $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
. $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/erik/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"

if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/erik/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/erik/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/erik/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export GOPATH=/Users/erik/.go
export PATH="/Users/erik/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
