# Requires zsh, oh-my-zsh, git, gpg, zoxide, fzf, jq
# Plugins zsh-autosuggestions and zsh-syntax-highlighting from https://github.com/zsh-users/
# must be cloned into $ZSH_CUSTOM/plugins.
#
# Machine-specific settings (agents, browser, SDK locations, project env vars) go in
# ~/.zshrc.local, which is not checked in.

###
# History and line editing
###

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt append_history autocd beep extendedglob nomatch notify

zstyle ':completion:*' completer _complete _ignored

###
# Environment
###

export LC_ALL='en_US.UTF-8'

export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.krew/bin:/usr/local/bin:/usr/local/sbin:$PATH

export ANSIBLE_SSH_ARGS="-o ControlMaster=auto -o ControlPersist=60s"
export ANSIBLE_TRANSPORT=ssh
export ANSIBLE_SSH_CONTROL_PATH='/tmp/%%h-%%r'

export JAVA_TOOL_OPTIONS='-Dfile.encoding=UTF8'

# Disable CLI pager
export AWS_PAGER=""

export GPG_TTY=$(tty)

if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export DISABLE_UPDATE_PROMPT=true

# Sourced before oh-my-zsh so plugins see per-machine settings (e.g. CLOUDSDK_HOME for gcloud).
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.secret.sh ]] && source ~/.secret.sh

###
# oh-my-zsh
###

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="nanotech"
plugins=(git aws brew docker kubectl 1password golang gcloud history-substring-search colorize zoxide zsh-autosuggestions zsh-syntax-highlighting)
[[ $OSTYPE == darwin* ]] && plugins+=(macos)

source $ZSH/oh-my-zsh.sh

###
# Key bindings (after oh-my-zsh so they aren't overridden)
###

# Fix for slow paste with autosuggestions
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# oh-my-zsh selects the emacs keymap, so bindings must come after it to take effect
bindkey '^H' backward-delete-word

###
# Language/tool version managers
###

export NVM_DIR="$HOME/.nvm"
for nvm_script in "$NVM_DIR/nvm.sh" "${HOMEBREW_PREFIX:-/usr/local}/opt/nvm/nvm.sh"; do
  if [[ -s $nvm_script ]]; then
    source "$nvm_script"
    [[ -s "${nvm_script:h}/bash_completion" ]] && source "${nvm_script:h}/bash_completion"
    [[ -s "${nvm_script:h}/etc/bash_completion.d/nvm" ]] && source "${nvm_script:h}/etc/bash_completion.d/nvm"
    break
  fi
done
unset nvm_script

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

if [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
  iterm2_print_user_vars() {
    iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
  }
fi

###
# Aliases (after oh-my-zsh, which defines its own ls alias)
###

if [[ $OSTYPE == darwin* ]]; then
  alias ls='ls -aG'
else
  alias ls='ls -a --color=tty'
fi
alias ll='ls -l'
alias l='ll'

alias u='cd ..'
alias uu='u;u'
alias uuu='u;u;u'

alias ud='u;cd'
alias uud='u;u;cd'
alias uuud='u;u;u;cd'

alias tf='terraform'

alias k='kubectl'
alias kp='k get pods'
alias kl='k logs -f'
alias kdp='k describe pod'

alias rv='gh repo view -w'
alias pv='gh pr view -w'

alias cr='claude -r'

alias c=zi

# Just for fun
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"

###
# Prompt
###

SHOW_RETURN_CODE='%(?,,%{$fg[red]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[red]%}] )'
PROMPT=" %F{green}%6c $SHOW_RETURN_CODE%F{blue}[%f "
RPROMPT='%{$fg[green]%}$(aws_workspace)%{$fg[white]%}$(git_origin)$(git_prompt_info) %F{blue}] %F{green}%*%f%'

GIT_CLEAN_COLOR="%{$fg[green]%}"
GIT_DIRTY_COLOR="%{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="% $GIT_DIRTY_COLOR ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="% $GIT_CLEAN_COLOR ✓"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"

# Not exported: only zsh completion uses these. Exporting would also recolor GNU ls.
LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

###
# Functions
###

urlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"
  REPLY="${encoded}"
}

urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

ksecret() {
  k get secret $@ -o json | jq '.data[] |= @base64d | .data'
}

kb() { k exec -it $1 "--" sh -c "(bash || sh)" }

bd() { echo "$1" | base64 -d }
be() { echo -n "$1" | base64 }

# 1Password: pick an item by title and show its fields
opget() { op item list --format json | jq -r '.[].title' | fzf -q "${1-}" | xargs -I{} op item get "{}" --format json | jq .fields }

# Shows the aws profile at the end of the prompt (e.g. (project-namespace))
aws_workspace() {
    [ -z $AWS_PROFILE ] || echo "($AWS_PROFILE-$KUBE_NAMESPACE) "
}

# Shows the origin repo name at the end of the prompt (e.g. dotfiles:)
git_origin() {
    git config -l | grep remote.origin.url | sed -E "s/.*\/(.*)\.git.*/\1:/"
}
