if status is-interactive
end

alias ls="eza"
alias l="eza -la"

set -g fish_greeting
set -Ux EDITOR = /opt/homebrew/bin/nvim
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml
set -Ux PATH $HOME/.bun/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -g NVM_DIR "$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . $NVM_DIR/nvm.sh

direnv hook fish | source
fzf --fish | source
starship init fish | source
zoxide init fish | source

eval "$(/opt/homebrew/bin/brew shellenv)"

