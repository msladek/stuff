# eternal bash history
HISTFILE=~/.bash_history_eternal
# make sure those line are commented out in .bashrc
HISTFILESIZE=
HISTSIZE=
# avoid duplicates
HISTCONTROL=ignoredups:erasedups
# enable timestamps
HISTTIMEFORMAT="[%F %T]  "
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
PS1=""
[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] \
  && PS1="${GREEN}\D{%y.%m.%d %H:%M}${nc} " \
[ "$USER" != 'msladek' ] && [ "$USER" != 'morrow' ] \
  && PS1="${PS1}${CYAN}\u${nc} "
PS1="${PS1}${BLUE}\w${nc}\$${nc} "
