## let wildcard * also match hidden files .*
shopt -s dotglob

## TODO check and only add if missing
PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin:/opt/bin

## set correct ssh auth socket if agent service is running 
systemctl --user status ssh-agent >/dev/null \
  && SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket
