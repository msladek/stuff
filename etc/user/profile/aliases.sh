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
alias ..='cd ../ && l'
alias ...='cd ../../ && l'
alias ....='cd ../../../ && l'
alias .....='cd ../../../../ && l'

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
command -v vi >/dev/null \
  && alias v='vi'
command -v vim >/dev/null \
  && alias vi='vim'
command -v nvim >/dev/null \
  && alias vim='nvim'
alias less='less --mouse --wheel-lines=5'
alias cmd='command'
alias ex='exit'
alias x='exit'
alias lsports='netstat -atulpn'
alias untar='tar -zxvf'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -pv'
alias ducks='du -cks * | sort -rn | head -11'
command -v fdfind >/dev/null \
  && alias fd='fdfind'

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
if command -v systemctl >/dev/null && systemctl status &>/dev/null; then
  alias sc='sudo SYSTEMD_EDITOR=vim systemctl'
  alias scu='SYSTEMD_EDITOR=vim systemctl --user'
  alias scs='systemctl status'
  alias scus='scu status'
  alias scf='systemctl --state=failed'
  alias scl='systemctl list-unit-files'
  alias sclu='systemctl list-units'
  alias sclt='systemctl list-timers --all'
  source /usr/share/bash-completion/completions/systemctl \
    && complete -F _systemctl sc
  source /usr/share/bash-completion/completions/systemctl \
    && complete -F _systemctl scu
fi

# journalctl aliases / completion
alias jc='sudo journalctl'
alias jcu='sudo journalctl -u'
alias jct='sudo journalctl -t'
source /usr/share/bash-completion/completions/journalctl \
  && complete -F _journalctl jc

# ufw
command -v ufw >/dev/null \
  && alias ufw="sudo ufw" \
  && alias ufws="ufw status numbered"

# git aliases / completion
if command -v git >/dev/null; then
  alias gia='git add'
  alias gib='git branch'
  alias gibl='git branch -lavv'
  alias gic='git commit'
  alias gicp='git cherry-pick'
  alias gico='git checkout'
  alias gid='git diff'
  alias gif='git fetch'
  alias gii='git init'
  alias gil='git log'
  alias gim='git merge'
  alias gio='git checkout'
  alias gip='git pull'
  alias gipl='git pull'
  alias gipu='git push'
  alias gir='git reset'
  alias gis='git status'
  alias giss='git status -s'
  alias giu='git push'
  alias gicu='git commit && git push'
  function gisw() {
    git switch ${1:+$(git rev-parse --verify "$1" &>/dev/null || ( git fetch && git rev-parse --verify "origin/$1" &>/dev/null ) || echo "-c")} "$1"
  }
  source /usr/share/bash-completion/completions/git \
    && __git_complete gia _git_add \
    && __git_complete gib _git_branch \
    && __git_complete gic _git_commit \
    && __git_complete gicp _git_cherry_pick \
    && __git_complete gico _git_checkout \
    && __git_complete gid _git_diff \
    && __git_complete gif _git_fetch \
    && __git_complete gii _git_init \
    && __git_complete gil _git_log \
    && __git_complete gim _git_merge \
    && __git_complete gio _git_checkout \
    && __git_complete gip _git_pull \
    && __git_complete gipl _git_pull \
    && __git_complete gipu _git_push \
    && __git_complete gir _git_reset \
    && __git_complete gis _git_status \
    && __git_complete giss _git_status \
    && __git_complete gisw _git_switch \
    && __git_complete giu _git_push \
    && __git_complete gicu _git_push
fi

# zfs aliases / completion
if command -v zfs >/dev/null; then
  alias zl='zfs list'
  alias zla='zfs list -t all'
  alias zls='zfs list -t snapshot'
  alias zlb='zfs list -t bookmark'
  source /usr/share/bash-completion/completions/zfs \
    && complete -F __zfs_complete zl \
    && complete -F __zfs_complete zla \
    && complete -F __zfs_complete zls \
    && complete -F __zfs_complete zlb
fi
