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
  && alias bat='batcat' \
  && alias batp='bat -p' \
  && alias cat='batp'
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
