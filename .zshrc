export EDITOR='nvim'
export VISUAL='nvim'
export PATH=$PATH:$HOME/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/dev/flutter/bin

# Completions (cached, skip security audit)
autoload -Uz compinit
compinit -C -u

# Plugins
source $HOME/.zsh-defer/zsh-defer.plugin.zsh
source $HOME/.oh-my-zsh/plugins/git/git.plugin.zsh
zsh-defer source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
zsh-defer source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

eval "$(zoxide init zsh)"
export KEYTIMEOUT=1
# Catppuccin Mocha colors for zsh-autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"

# Catppuccin Mocha colors for zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#89b4fa,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#cdd6f4'

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt AUTO_CD
bindkey -v
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char

# Up/Down arrow: cycle through history entries matching current prefix
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

alias ys='yarn start'
alias ns='npm start'
alias dev='cd && dev/'
alias c='claude'
alias cc='claude -c'
alias e='exit'
alias n='nvim'
alias v='vim'
alias p='pi'
alias ni='cd && .config/nvim && n'
# eza with OSC 8 hyperlinks → Alt+click in kitty opens files in tmux nvim split.
alias ls='eza --icons --color=always --hyperlink'
alias ll='eza -l --icons --color=always --hyperlink'
alias la='eza -la --icons --color=always --hyperlink'
alias tree='eza --tree --icons --color=always --hyperlink'
alias gk='/opt/homebrew/bin/gk'
# Lazy load nvm for faster startup
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Auto-load nvm when entering directory with .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -s "$NVM_DIR/nvm.sh" ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

export LANG="en_US.UTF-8"


# Native prompt with git info
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b%f %F{red}(%a)%f'
precmd() { vcs_info }
setopt PROMPT_SUBST

if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  PROMPT='%n@%m:%~%# '
  RPROMPT=''
else
  PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %F{green}❯%f '
fi


alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

et() {
    encore test -run "$1" -v
}

ulimit -n 10240




# Auto-switch gh CLI account based on current directory:
# ~/base/dutch/* -> taras-lysyi-solid (work)
# everything else -> taras-lysyi (personal)
_auto_switch_gh_account() {
  if [[ "$PWD" = "$HOME/base/dutch"* || "$PWD" = "$HOME/.worktrees/emr"* ]]; then
    gh auth switch --user taras-lysyi-solid 2>/dev/null
  else
    gh auth switch --user taras-lysyi 2>/dev/null
  fi
}
add-zsh-hook chpwd _auto_switch_gh_account

# Auto-switch Claude Code account based on current directory:
# ~/base/dutch/* -> work account (~/.claude-work)
# everything else -> personal account (~/.claude, default)
_auto_switch_claude_account() {
  if [[ "$PWD" = "$HOME/base/dutch"* || "$PWD" = "$HOME/.worktrees/emr"* ]]; then
    export CLAUDE_CONFIG_DIR="$HOME/.claude-work"
  else
    unset CLAUDE_CONFIG_DIR
  fi
}
add-zsh-hook chpwd _auto_switch_claude_account

# Run once on shell startup (chpwd only fires on cd, not initial shell)
_auto_switch_gh_account
_auto_switch_claude_account

# Jira credentials
[ -f "$HOME/.jira.env" ] && source "$HOME/.jira.env"

# Lazy-load Google Cloud SDK for faster startup
gcloud() {
  unset -f gcloud
  if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
  fi
  if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
  fi
  gcloud "$@"
}
export PATH="/opt/homebrew/opt/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/fvm/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

