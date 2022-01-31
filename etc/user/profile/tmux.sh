if command -v tmux >/dev/null; then
  # check if already in tmux
  if [ "$TERM_PROGRAM" = tmux ]; then
    # for nested tmux don't let the remote host know about local tmux
    alias ssh='TERM=xterm-256color ssh'
    # run neofetch within tmux if we're remote
    [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] \
      && command -v neofetch >/dev/null \
      && neofetch
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
