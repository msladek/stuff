## let wildcard * also match hidden files .*
shopt -s dotglob

## complete PATH environment variable
paths="
  ${HOME}/.local/bin
  ${HOME}/bin
  ${HOME}/.npm-global/bin
  /usr/local/sbin
  /usr/local/bin
  /usr/sbin
  /usr/bin
  /opt/sbin
  /opt/bin
  /sbin
  /bin
"
for p in $paths; do
  [ -d "$p" ] \
    && [[ ":${PATH}:" != *":${p}:"* ]] \
    && PATH=$PATH:$p
done
unset p paths

export GPG_TTY=$(tty)

## set correct ssh auth socket if agent service is running
command -v systemctl >/dev/null \
  && systemctl --user status ssh-agent &>/dev/null \
  && export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket

command -v fzf >/dev/null \
  && [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] \
  && source /usr/share/doc/fzf/examples/key-bindings.bash

## set keyboard layout to Swiss (X11 still needed for x2go)
setxkbmap ch 2> /dev/null
