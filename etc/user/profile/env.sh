## let wildcard * also match hidden files .*
shopt -s dotglob

## complete PATH environment variable
paths="
  ${HOME}/.local/bin
  ${HOME}/bin
  ${HOME}/.npm-global/bin
  /usr/local/bin
  /usr/bin
  /bin
  /opt/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  /opt/sbin
"
for p in $paths; do
  [ -d "$p" ] \
    && [[ ":${PATH}:" != *":${p}:"* ]] \
    && PATH=$PATH:$p
done
unset p paths

## set correct ssh auth socket if agent service is running
command -v systemctl >/dev/null \
  && systemctl --user status ssh-agent &>/dev/null \
  && export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket
