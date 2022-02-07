function mkcd() {
  dir="${@: -1}"
  parent="$dir"
  while [ ! -d "$parent" ]; do parent=$(dirname "$parent"); done
  [ -w "$parent" ] \
    && mkdir "$@" \
    || { sudo mkdir "$@" \
      && sudo chown $USER:$(id -gn) "$dir"; } \
    && cd "$dir"
}

function tailf() {
  [ -r "${@: -1}" ] && local sudo='' || local sudo='sudo'
  $sudo tail -f -n1000 "$@"
}

function lessf() {
  [ -r "${@: -1}" ] && local sudo='' || local sudo='sudo'
  $sudo less -n +F "$@"
}

if command -v aptitude >/dev/null; then
function update() {
  local hold=$(sudo apt-mark showhold)
  [ $hold ] && echo -e "\e[0;91mpackages held back:\e[0m ${hold}" && echo
  aptitude "$@" update \
    && aptitude upgrade \
    && aptitude autoclean && echo \
    && apt autoremove && echo
  ret=$?
  [ $ret -eq 0 ] && command -v checkrestart >/dev/null \
    && echo "check restarts:" && sudo checkrestart
  [ $ret -eq 0 ] && command -v check-support-status >/dev/null \
    && echo "check support:" && sudo check-support-status
  return $ret
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

if command -v git >/dev/null; then
# pull repo with mixed permissions
function git-pull-force() {
  git="git -C $1"
  $git fetch || return 1
  $git clean --interactive
  $git reset --hard
  local branch=$($git remote | head -n1)/$($git branch --show-current)  
  for file in $($git diff --name-only @ @{u}); do
    [ -w "$file" ] && local sudo='' || local sudo='sudo'
    $sudo $git checkout $branch $file \
      || return 1
  done
  $git pull
}
fi #git