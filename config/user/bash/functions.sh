function mkcd() {
  [ -w "./" ] && mkdir "$@" || (sudo mkdir "$@" && sudo chown $USER:$USER "${@: -1}") && cd "${@: -1}"
  return $?
}

function tailf() {
  [ -r "${@: -1}" ] && tail -f -n1000 "$@" \
               || sudo tail -f -n1000 "$@"
  return $?
}

function lessf() {
  [ -r "${@: -1}" ] && less -n +F "$@" \
               || sudo less -n +F "$@"
  return $?
}

if command -v aptitude >/dev/null; then
function update() {
  local hold=$(sudo apt-mark showhold)
  [ $hold ] && echo -e "\e[0;91mpackages held back:\e[0m ${hold}" && echo
  sudo aptitude update \
    && sudo aptitude upgrade \
    && sudo aptitude autoclean && echo \
    && echo "check restarts:" && sudo checkrestart
}
fi

function ssh-add-once() {
  command ssh-add -l | grep -q $(ssh-keygen -lf $1 | awk '{print $2}') && echo "already added: $1" || command ssh-add $1
  return $?
}

function ssh-add-fromcfg() {
  if [ -n "$1" ]; then
    local sshHostName=$(    cat $HOME/.ssh/config | sed -n "/Host.* $1/,/Host /p" | grep 'HostName'     | awk '{print $2}' | sed "s|%h|$1|g")
    local sshIdentityFile=$(cat $HOME/.ssh/config | sed -n "/Host.* $1/,/Host /p" | grep 'IdentityFile' | awk '{print $2}' | sed "s|%h|${sshHostName}|g")
    local sshProxyJump=$(   cat $HOME/.ssh/config | sed -n "/Host.* $1/,/Host /p" | grep 'ProxyJump'    | awk '{print $2}' | sed "s|%h|$1|g")
    ssh-add-fromcfg $sshProxyJump
    [ -z "${sshIdentityFile// }" ] && echo "Unable to determine identity file for: $1" \
	    || eval ssh-add-once $sshIdentityFile
  fi
  return $?
}

function ssh-custom() {
  [ "$#" -eq 1 ] && ssh-add-fromcfg $1
  command ssh "$@"
  return $?
}
