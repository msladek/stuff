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
command -v doas >/dev/null \
  && alias sudo='doas '

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

# colorize grep output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# colorize diff output
command -v colordiff >/dev/null \
  alias diff='colordiff'

alias apt="sudo apt"
alias aptitude="sudo aptitude"

# give cat some wings
command -v batcat >/dev/null \
  && alias bat='batcat' \
  && alias batp='bat -p' \
  && alias cat='batp'

# other aliases
alias vi='vim'
alias lsports='sudo netstat -atulpn'
alias untar='tar -zxvf'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -pv'
alias ducks='du -cks * | sort -rn | head -11'

# tmux/screen simplifications
command -v screen >/dev/null \
  && alias screenr='screen -RR'
command -v tmux >/dev/null \
  && alias t='tmux attach || tmux new-session' \
  && alias ta='tmux attach -t' \
  && alias tn='tmux new-session' \
  && alias tc='tmux new-session' \
  && alias tl='tmux list-sessions'
