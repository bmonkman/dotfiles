# Requires zsh, iterm2, docker, nvm, google-cloud-sdk, git, gpg, ccat
# Plugins from https://github.com/zsh-users/

# The following lines were added by compinstall
if [ -d "$HOME/Library/Python/2.7/bin" ]; then
    PATH="$HOME/Library/Python/2.7/bin:$PATH"
fi

export ZSH=/Users/$USER/.oh-my-zsh
ZSH_THEME="nanotech"
plugins=(git aws brew docker go osx zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting kubectl)
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Fix for slow paste with autosuggestions
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
#source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
zstyle ':bracketed-paste-magic' active-widgets '.self-*'


zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^R' history-incremental-search-backward



zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/Users/$USER/.zshrc'

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt append_history autocd beep nomatch notify
# share_history

bindkey -v
export KEYTIMEOUT=1
# End of lines configured by zsh-newuser-install


alias ls='ls -aG'
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

export LC_ALL='en_US.UTF-8'



# MacPorts Installer addition on 2013-02-12_at_15:19:45: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export ANSIBLE_SSH_ARGS="-o ControlMaster=auto -o ControlPersist=60s"
export ANSIBLE_TRANSPORT=ssh
export ANSIBLE_SSH_CONTROL_PATH='/tmp/%%h-%%r'

export JAVA_TOOL_OPTIONS='-Dfile.encoding=UTF8'
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"


export GOROOT=/usr/local/Cellar/go/1.18/libexec

export SBT_OPTS="-XX:MaxPermSize=1024m -XX:+CMSClassUnloadingEnabled"


# Disable CLI pager
export AWS_PAGER=""

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH=/usr/local/opt/python@3.8/bin:~/bin:/usr/local/sbin:/usr/local/pear/bin:${HOME}/go/bin:${HOME}/.krew/bin:${PATH}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

function iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}


#/usr/local/bin/gpgconf --launch gpg-agent
export GPG_TTY=`tty`

source $ZSH/oh-my-zsh.sh


# Customize theme



SHOW_RETURN_CODE='%(?,,%{$fg[red]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[red]%}] )'
PROMPT=" %F{green}%6c $SHOW_RETURN_CODE%F{blue}[%f "
RPROMPT='%{$fg[green]%}$(aws_workspace)%{$fg[white]%}$(git_origin)$(git_prompt_info) %F{blue}] %F{green}%*%f%'

GIT_CLEAN_COLOR="%{$fg[green]%}"
GIT_DIRTY_COLOR="%{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="% $GIT_DIRTY_COLOR ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="% $GIT_CLEAN_COLOR ✓"

# Yellow autosuggest
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"

###

LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
export LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

alias cat=ccat

# Just for fun

alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"

source ~/.secret.sh



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/billmonkman/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/billmonkman/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/billmonkman/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/billmonkman/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Enable Z command - Replaced by zoxide
#export _Z_USE_ZSYSTEM_FLOCK=1
#. ~/Projects/dotfiles/z.sh

# Provided by zoxide now
#fz () {
#	local dir=$(z | cut -c 12- | fzf --tac --select-1 -q "$1")  && cd "$dir"
#}

eval "$(zoxide init zsh)"

alias c=zi

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
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

ksecret() {
  k get secret $@ -o json | jq '.data[] |= @base64d | .data'
}

kb() { k exec -it $1 "--" sh -c "(bash || sh)" }

bd() { echo "$1" | base64 -D }
be() { echo -n "$1" | base64 }

# For 1Password
opget() { op list items | jq ".[].overview.title"  | fzf -q ${1-""} | xargs op get item | jq .details }

# Function to show the aws workspace at the end of the prompt (e.g. (project))
aws_workspace() {
    [ -z $AWS_PROFILE ] || echo "($AWS_PROFILE-$KUBE_NAMESPACE) "
}

# Function to show the origin at the end of the prompt (e.g. web/dashboard)
git_origin() {
    git config -l | grep remote.origin.url | sed -E "s/.*\/(.*)\.git.*/\1:/"
}
