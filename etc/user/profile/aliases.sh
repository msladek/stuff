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
command -v doas >/dev/null \
  && alias sudo='doas ' \
  && alias apt='doas apt' \
  && alias aptitude='doas aptitude'

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
  && alias screenr='tmuxr'

# zfs aliases
command -v zfs >/dev/null \
  && alias zl='zfs list' \
  && alias zla='zfs list -t all' \
  && alias zls='zfs list -t snapshot'
