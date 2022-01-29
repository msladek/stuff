if command -v enpasscli >/dev/null; then

upid="/tmp/upid"
[ ! -f "$upid" ] \
  && install -T -m 600 /dev/null $upid \
  && openssl rand -base64 32  > $upid

export enp_vault=~/.enpasscli/vault
export enp_keyfile=~/.enpasscli/keyfile
export ENP_PIN_ITER_COUNT=2000000

alias enpls='enp -sort list'
alias enpsh='enp -sort show'
alias enpcp='enp -clipboardPrimary copy'
alias enppw='enp pass'

function enp() {
  enp_params="-pin -vault=${enp_vault} -keyfile=${enp_keyfile}"
  local pin="$ENP_PIN"
  [ -z "$pin" ] && read -s -p "Enter PIN: " pin && echo 1>&2
  ENP_PIN=$pin ENP_PIN_PEPPER=$(cat ${upid}) enpasscli $enp_params "$@"
  local exit_code=$?
  [ $exit_code -eq 0 ] && [ -z "$ENP_PIN" ] && [ -n "$pin" ] \
    && export ENP_PIN=$pin \
    && trap 'unset ENP_PIN' SIGUSR1 \
    && local current_pid=$BASHPID \
    && (( sleep 300; kill -SIGUSR1 $current_pid ) & ) > /dev/null 2>&1
  return $exit_code
}

if command -v enpass-askpass >/dev/null; then
alias ssh='ssh-enp'
function ssh-enp() {
  local require=never
  ! ssh-add-has "${@: -1}" && enp dryrun && require=force
  SSH_ASKPASS=enpass-askpass SSH_ASKPASS_REQUIRE=$require command ssh "$@"
}
alias ssh-add='ssh-enp-add'
function ssh-enp-add() {
  local require=never
  ! ssh-add-has "${@: -1}" && enp dryrun && require=force
  SSH_ASKPASS=enpass-askpass SSH_ASKPASS_REQUIRE=$require ssh-add-once "$@"
}
fi #enpass-askpass

fi #enpasscli
