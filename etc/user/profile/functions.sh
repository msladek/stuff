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
  aptitude "$@" update \
    && aptitude upgrade \
    && aptitude autoclean && echo \
    && apt autoremove && echo \
    && echo "check restarts:" && sudo checkrestart
}
fi

function ssh-cfg-has() {
  [ ! -z "$1" ] && [[ $1 != -* ]] && ! command ssh -G $1 | grep -q "^identityfile ~/.ssh/id_rsa$"
}

function ssh-cfg-get() {
  command ssh -G $1 | grep "^${2,,} " | head -1 | awk '{print $2}'
}

function ssh-add-has() {
  local identityFile="${1/#\~/$HOME}"
  if [ -f "$identityFile" ]; then
    command ssh-add -l | grep -q $(ssh-keygen -lf "$identityFile" | awk '{print $2}')
  elif ssh-cfg-has $1; then
    ssh-add-has $(ssh-cfg-get $1 'ProxyJump') && \
    ssh-add-has $(ssh-cfg-get $1 'IdentityFile')
  fi
}

alias ssh-add='ssh-add-once'
function ssh-add-once() {
  local identityFile="${1/#\~/$HOME}"
  if [ -f "$identityFile" ]; then
    ssh-add-has "$identityFile" \
      && echo "identity already added: $1" \
      || command ssh-add "$identityFile"
  elif ssh-cfg-has $1; then
    ssh-add-once $(ssh-cfg-get $1 'ProxyJump')
    ssh-add-once $(ssh-cfg-get $1 'IdentityFile')
  else
    command ssh-add "$@"
  fi
}
