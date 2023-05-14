if command -v tmux >/dev/null; then
  # check if already in tmux, TERM_PROGRAM set in 3.2+
  # https://github.com/tmux/tmux/commit/4e053685df9f4d1c398148712ab0529a7e9d32e7
  if [[ "$TERM_PROGRAM" == tmux ]] || [[ -n "$TMUX" ]]; then
    # run motd within tmux if we're remote
    [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]] \
      && [[ -d /etc/update-motd.d ]] \
      && run-parts /etc/update-motd.d
  elif [[ -n "$PS1" ]] && [[ $- == *i* ]] \
    && [[ ! "$TERM" == dumb ]] \
    && [[ ! "$TERM" =~ screen ]] \
    && [[ ! "$TERM_PROGRAM" == vscode ]]; then
    # open/attach tmux session 'main' if
    # 1. tmux is installed
    # 2. we aren't already within tmux
    # 3. we are in an interactive terminal
    # 4. we aren't within a dumb terminal
    # 4. we aren't within screen
    # 5. we aren't within vscode
    exec tmux new-session -A -s main
  fi
fi
