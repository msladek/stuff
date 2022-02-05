if command -v tmux >/dev/null; then
  # check if already in tmux, TERM_PROGRAM set in 3.2+
  # https://github.com/tmux/tmux/commit/4e053685df9f4d1c398148712ab0529a7e9d32e7
  if [ "$TERM_PROGRAM" = tmux ] || [ -n "$TMUX" ]; then
    # run motd within tmux if we're remote
    [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] \
      && run-parts /etc/update-motd.d \
      && last --time-format=iso $USER \
       | grep 'pts' | egrep -v "tmux|:S"
       | head -n2 | tail -n1 \
       | awk {'print "Last login: " $4 " from " $3'}
  elif [ -n "$PS1" ] && [[ $- == *i* ]] \
    && [[ ! "$TERM" =~ screen ]] \
    && [ ! "$TERM_PROGRAM" = vscode ]; then
    # open/attach tmux session 'main' if
    # 1. tmux is installed
    # 2. we aren't already within tmux
    # 3. we are in a interactive terminal
    # 4. we aren't within screen
    # 5. we aren't within vscode
    exec tmux new-session -A -s main
  fi
fi
