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
alias apt="sudo apt"
alias aptitude="sudo aptitude"

# some more ls aliases
command -v lsd >/dev/null \
  && alias ls='lsd'
alias l='ls -Flh --color=auto'
alias ll='ls -aFlh --color=auto'
alias la='ls -AFlh --color=auto'

# aliases for backing out of dirs
alias ..='cd ../ && ll'
alias ...='cd ../../ && ll'
alias ....='cd ../../../ && ll'
alias .....='cd ../../../../ && ll'

# colorize outputs
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
command -v colordiff >/dev/null \
  alias diff='colordiff'

# give cat some wings
command -v batcat >/dev/null \
  && alias bat='batcat' \
  && alias batp='bat -p' \
  && alias cat='batp'

# other aliases
command -v vim >/dev/null \
  && alias vi='vim'
alias less='less --mouse --wheel-lines=5'
alias cmd='command'
alias ex='exit'
alias lsports='netstat -atulpn'
alias untar='tar -zxvf'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -pv'
alias ducks='du -cks * | sort -rn | head -11'

# tmux/screen aliases
command -v screen >/dev/null \
  && alias screenr='screen -RR'
command -v tmux >/dev/null \
  && alias tmuxr='tmux attach || tmux new-session' \
  && alias screen='tmux' \
  && alias screenr='tmuxr' \
# for nesting tmux don't let the remote host know about local tmux
[ "$TERM_PROGRAM" = tmux ] || [ -n "$TMUX" ] \
  && alias ssh='TERM=xterm-256color ssh'

# systemctl aliases / completion
alias sc='sudo SYSTEMD_EDITOR=vim systemctl'
alias scs='systemctl status'
alias scl='systemctl list-unit-files'
alias sclu='systemctl list-units'
alias sclt='systemctl list-timers --all'
source /usr/share/bash-completion/completions/systemctl \
  && complete -F _systemctl sc

# journalctl aliases / completion
alias jc='sudo journalctl'
source /usr/share/bash-completion/completions/journalctl \
  && complete -F _journalctl jc

# git aliases / completion
if command -v git >/dev/null; then
  alias gia='git add'
  alias gib='git branch'
  alias gic='git commit'
  alias gid='git diff'
  alias gif='git fetch'
  alias gii='git init'
  alias gil='git log'
  alias gim='git merge'
  alias gio='git checkout'
  alias gip='git pull'
  alias gir='git reset'
  alias gis='git status'
  alias giu='git push -u'
  alias gicu='git commit && git push -u'
  source /usr/share/bash-completion/completions/git \
    && __git_complete gia _git_add \
    && __git_complete gib _git_branch \
    && __git_complete gic _git_commit \
    && __git_complete gid _git_diff \
    && __git_complete gif _git_fetch \
    && __git_complete gii _git_init \
    && __git_complete gil _git_log \
    && __git_complete gim _git_merge \
    && __git_complete gio _git_checkout \
    && __git_complete gip _git_pull \
    && __git_complete gir _git_reset \
    && __git_complete gis _git_status \
    && __git_complete giu _git_push \
    && __git_complete gicu _git_push
fi

# zfs aliases / completion
if command -v zfs >/dev/null; then
  alias zl='zfs list'
  alias zla='zfs list -t all'
  alias zls='zfs list -t snapshot'
  source /usr/share/bash-completion/completions/zfs \
    && complete -F __zfs_complete zl \
    && complete -F __zfs_complete zla \
    && complete -F __zfs_complete zls
fi
