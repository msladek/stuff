if command -v enpasscli >/dev/null; then

[ ! -f /tmp/upid ] \
  && install -T -m 600 /dev/null /tmp/upid \
  && openssl rand -base64 32  > /tmp/upid

export enp_vault=~/.enpasscli/vault
export enp_keyfile=~/.enpasscli/keyfile
export ENP_PIN_ITER_COUNT=2000000

alias enpls='enp -sort list'
alias enpsh='enp -sort show'
alias enpcp='enp-copy-primary'
alias enppw='enp pass'

function enp() {
  enp_params="-and -pin -vault=${enp_vault} -keyfile=${enp_keyfile}"
  local pin="$ENP_PIN"
  [ -z "$pin" ] && read -s -p "Enter PIN: " pin && echo 1>&2
  ENP_PIN=$pin ENP_PIN_PEPPER=$(cat /tmp/upid) enpasscli $enp_params "$@"
  local exit_code=$?
  [ $exit_code -eq 0 ] && [ -z "$ENP_PIN" ] && [ -n "$pin" ] \
    && export ENP_PIN=$pin \
    && _enp-kill-bg-process ENP_CLEAR_PIN \
    && trap 'unset ENP_PIN' SIGUSR2 \
    && local current_pid=$BASHPID \
    && ( (ENP_CLEAR_PIN=true sleep 300 && kill -SIGUSR2 $current_pid) & )
  return $exit_code
}

function enp-copy-primary() {
  enp -clipboardPrimary copy "$@" \
    && _enp-kill-bg-process ENP_CLEAR_XSEL \
    && trap 'xsel -c' SIGUSR1 \
    && local current_pid=$BASHPID \
    && ( (ENP_CLEAR_XSEL=true sleep 30 && kill -SIGUSR1 $current_pid) & )
}

function _enp-kill-bg-process() {
  [ -z "$1" ] && return 1
  for pid in $(pgrep sleep); do
    strings /proc/${pid}/environ | grep -qF "${1}=true" \
      && kill -INT $pid
  done
  return 0
}

if command -v enpass-askpass >/dev/null; then
function ssh() { ssh-enp "$@"; }
function ssh-enp() {
  local require=never
  ! ssh-add-has "${@: -1}" && enp dryrun && require=force
  SSH_ASKPASS=enpass-askpass SSH_ASKPASS_REQUIRE=$require command ssh "$@"
}
function ssh-add() { ssh-enp-add "$@"; }
function ssh-enp-add() {
  local require=never
  ! ssh-add-has "${@: -1}" && enp dryrun && require=force
  SSH_ASKPASS=enpass-askpass SSH_ASKPASS_REQUIRE=$require ssh-add-once "$@"
}
fi #enpass-askpass

fi #enpasscli
