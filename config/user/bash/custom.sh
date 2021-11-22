## TODO check and only add if missing
PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin:/opt/bin

## set correct ssh auth socket if agent service is running 
systemctl --user status ssh-agent >/dev/null \
  && SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket

# history without limits
HISTFILESIZE=
HISTSIZE=
# avoid duplicates
HISTCONTROL=ignoredups:erasedups
# enable timestamps
HISTTIMEFORMAT="%F %T  "
# when the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# after each command, append to the history file
PROMPT_COMMAND="history -a"

# colors
red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]'
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
PURPLE='\[\e[1;35m\]'
purple='\[\e[0;35m\]'
nc='\[\e[0m\]'

# bash prompt
PS1="${YELLOW}\u${nc}@${BLUE}\H${nc}:${CYAN}[\D{%Y.%m.%d %H:%M}]${nc}:${GREEN}\w${nc}${GREEN}\$${nc} "

# safety nets
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# sudo stuff
alias sudo='sudo '

# some more ls aliases
alias l='ls -Flh --color=auto'
alias ll='ls -aFlh --color=auto'
alias la='ls -AFlh --color=auto'

# aliases for backing out of dirs
alias ..='cd ../ && ll'
alias ...='cd ../../ && ll'
alias ....='cd ../../../ && ll'
alias .....='cd ../../../../ && ll'

# other aliases
command -v batcat >/dev/null \
  && alias bat=batcat \
  && alias cat=batcat
alias lsports='sudo netstat -tulpn'
alias untar='tar -zxvf'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -pv'
alias ducks='du -cks * | sort -rn | head -11'
command -v screen >/dev/null \
  && alias screenr='screen -RR'
command -v tmux >/dev/null \
  && alias t='tmux attach || tmux new-session' \
  && alias ta='tmux attach -t' \
  && alias tn='tmux new-session' \
  && alias tc='tmux new-session' \
  && alias tl='tmux list-sessions'

function mkcd() {
  [ -w "./" ] && mkdir "$@" || (sudo mkdir "$@" && sudo chown $USER:$USER "${@: -1}") && cd "${@: -1}"
  return $?
}

function tailf() {
  [ -r "${@: -1}" ] && tail -f -n1000 "$@" \
               || sudo tail -f -n1000 "$@"
  return $?
}

function lessf() {
  [ -r "${@: -1}" ] && less -n +F "$@" \
               || sudo less -n +F "$@"
  return $?
}

if command -v aptitude >/dev/null; then
function update() {
  local hold=$(sudo apt-mark showhold)
  [ $hold ] && echo -e "\e[0;91mpackages held back:\e[0m ${hold}" && echo
  sudo aptitude update \
    && sudo aptitude upgrade \
    && sudo aptitude autoclean && echo \
    && echo "check restarts:" && sudo checkrestart
}
fi

function ssh-add-once() {
  command ssh-add -l | grep -q $(ssh-keygen -lf $1 | awk '{print $2}') && echo "already added: $1" || command ssh-add $1
  return $?
}

function ssh-add-fromcfg() {
  if [ -n "$1" ]; then
    local sshHostName=$(    cat $HOME/.ssh/config | sed -n "/Host.* $1/,/Host /p" | grep 'HostName'     | awk '{print $2}' | sed "s|%h|$1|g")
    local sshIdentityFile=$(cat $HOME/.ssh/config | sed -n "/Host.* $1/,/Host /p" | grep 'IdentityFile' | awk '{print $2}' | sed "s|%h|${sshHostName}|g")
    local sshProxyJump=$(   cat $HOME/.ssh/config | sed -n "/Host.* $1/,/Host /p" | grep 'ProxyJump'    | awk '{print $2}' | sed "s|%h|$1|g")
    ssh-add-fromcfg $sshProxyJump
    [ -z "${sshIdentityFile// }" ] && echo "Unable to determine identity file for: $1" \
	    || eval ssh-add-once $sshIdentityFile
  fi
  return $?
}

function ssh-custom() {
  [ "$#" -eq 1 ] && ssh-add-fromcfg $1
  command ssh "$@"
  return $?
}

if command -v enpasscli+ >/dev/null; then
alias enpls='enp list'
alias enpsh='enp show'
alias enpcp='enp copy'
function enp() {
  [ -z "$enp_pin" ] \
    && read -s -p "Enter PIN (or omit): " enp_pin && echo \
    && export enp_pin
  export pbkdf2_iter="1000000"
  enpasscli+ "$@" \
    || unset enp_pin
  return $?
}
fi
