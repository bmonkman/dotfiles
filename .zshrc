# Requires zsh, iterm2, docker, nvm, google-cloud-sdk, git, gpg, ccat
# Plugins from https://github.com/zsh-users/

# The following lines were added by compinstall
if [ -d "$HOME/Library/Python/2.7/bin" ]; then
    PATH="$HOME/Library/Python/2.7/bin:$PATH"
fi

export ZSH=/Users/$USER/.oh-my-zsh
ZSH_THEME="nanotech"
plugins=(git aws brew docker composer go osx zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting kubectl)
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh


zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down



zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/Users/$USER/.zshrc'

autoload -Uz compinit
compinit
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

export LC_ALL='en_US.UTF-8'



# MacPorts Installer addition on 2013-02-12_at_15:19:45: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export ANSIBLE_SSH_ARGS="-o ControlMaster=auto -o ControlPersist=60s"
export ANSIBLE_TRANSPORT=ssh
export ANSIBLE_SSH_CONTROL_PATH='/tmp/%%h-%%r'

export JAVA_TOOL_OPTIONS='-Dfile.encoding=UTF8'
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"


export GOPATH=$HOME/go

export SBT_OPTS="-XX:MaxPermSize=1024m -XX:+CMSClassUnloadingEnabled"

bindkey '^R' history-incremental-search-backward



#docker-machine
eval $(timeout 3 docker-machine env dev 2>/dev/null)

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export PATH=~/bin:/usr/local/sbin:/usr/local/pear/bin:$GOPATH/bin:$PATH

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

function iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}


/usr/local/bin/gpgconf --launch gpg-agent
export GPG_TTY=`tty`

source $ZSH/oh-my-zsh.sh


# Customize theme

# Function to show the origin at the end of the prompt (e.g. web/dashboard)
function git_origin() {
    git config -l | grep remote.origin.url | sed -E "s/.*\/(.*)\.git.*/\1:/"
}

SHOW_RETURN_CODE='%(?,,%{$fg[red]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[red]%}] )'
PROMPT=" %F{green}%6c $SHOW_RETURN_CODE%F{blue}[%f "
RPROMPT='$(git_origin)$(git_prompt_info) %F{blue}] %F{green}%*%f%'

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
source ~/.bench.sh



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/billmonkman/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/billmonkman/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/billmonkman/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/billmonkman/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
