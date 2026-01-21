# TODO: fix path repetition (i.e. blow out path customization each time)
alias erc='nvim ~/.zshrc && source ~/.zshrc'

# General handy
mkcd () {
	mkdir -p $1
	cd $1
}

function poll() {
	until $@; do
		sleep 1
		printf .
   	done
}

bindkey '\e\e[D' backward-word
bindkey '\e\e[C' forward-word

set -o shwordsplit

alias watch='watch -n 1 -t '
alias uuidgen="uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]'"

alias g='git'
alias cb='g br --show-current'
alias ga='g a'
alias gca='g a . && g cm --amend --no-edit'
alias gp='g p origin $(cb)'
alias gpf='g p --force origin $(cb)'
alias grm='g fetch origin && g co main && g reset --hard origin/main'
alias grbm='g fetch origin && g rb -i origin/main'
alias gdif='g diff origin/main'
alias gd='g diff origin/main --name-only'
# git resolve conflicts
alias grc='nvim $(git diff --name-only --diff-filter=U --relative)'
alias gbr='g rev-parse --abbrev-ref HEAD'

# Read: "git worktree branch"
gwtb() {
	if [ -z "$1" ]; then
		echo "Usage: gwtb <branch-name>"
		return 1
	fi
	git worktree add "../$1" -b "$1" && cd "../$1"
}

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

alias tf='terraform'

alias pip='pip3'

vim-matches () {
	nvim $(grep -rliI "$1" .)
}

alias rsi='nvim -R -'

export VISUAL=nvim
export EDITOR="$VISUAL"

# tmux aliases
alias tnew='tmux new -s'
alias tls='tmux ls'
alias ta='tmux a -t'
alias td='tmux kill-session -t'
alias tmv='tmux rename-session -t'

use-go () {
	sudo rm /usr/local/go
	sudo ln -s /usr/local/go${1} /usr/local/go
}

# Golang cfg
export GOPATH=${HOME}/go
export GOBIN="${GOPATH}/bin"
export PATH="${GOBIN}:${PATH}"
export GOPRIVATE=github.com/1debit/*
alias go18=/usr/local/go18/bin/go

# Created by `pipx` on 2021-03-24 20:55:52
export PATH="$PATH:/Users/ryan.flynn/.local/bin"

# Spark config
export SPARK_HOME="$HOME/spark"
export PATH="$SPARK_HOME/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Postgres tools
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Tokens
source $HOME/.envtokens/.env

# AWS
export AWS_REGION=us-east-1
function awslocal() {
	AWS_PROFILE=localstack aws --endpoint http://localhost:4566 "$@"
}

# k8s
source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

alias kctx="kubectx"
alias kns="kubectl config set-context --current --namespace"

# Docker
alias dkr_kill='docker kill $(docker ps -aq); docker rm $(docker ps -aq)'
function dkr_chime_login() {
	aws ecr get-login-password --region us-east-1 | docker login \
		--username AWS \
		--password-stdin 358789136651.dkr.ecr.us-east-1.amazonaws.com
}

# zsh auto suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '\t\t' autosuggest-accept
bindkey '^[[C' forward-word
bindkey '^I'  expand-or-complete
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(expand-or-complete)

# Source local/work-specific config if it exists
if [ -f ~/.zshrc.local ]; then
	source ~/.zshrc.local
fi
