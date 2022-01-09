if command -v enpasscli >/dev/null; then

[ -d "$XDG_RUNTIME_DIR" ] && [ ! -f "${XDG_RUNTIME_DIR}/upid" ] \
  && openssl rand -base64 32  > ${XDG_RUNTIME_DIR}/upid

export enp_vault=$HOME/.enpasscli/vault
export enp_keyfile=$HOME/.enpasscli/keyfile

alias enpls='enp list -sort'
alias enpsh='enp show -sort'
alias enpcp='enp copy -clipboardPrimary'
alias enppw='enp pass'

function enp() {
  local pin="$PIN"
  [ -z "$pin" ] \
    && read -s -p "Enter PIN: " pin && echo 1>&2
  enp_params="-pin -vault=${enp_vault} -keyfile=${enp_keyfile}"
  PIN=$pin enpasscli $enp_params "$@"
  local exit_code=$?
  [ $exit_code -eq 0 ] && [ -z "$PIN" ] && [ -n "$pin" ] \
    && export PIN=$pin \
    && trap 'unset PIN' SIGUSR1 \
    && local current_pid=$BASHPID \
    && (( sleep 300; kill -SIGUSR1 $current_pid ) & ) > /dev/null 2>&1
  return $exit_code
}

if command -v enpass-askpass >/dev/null; then
function ssh-enp() {
  local require=never
  ! ssh-add-has "${@: -1}" && enp init && require=force
  SSH_ASKPASS=enpass-askpass SSH_ASKPASS_REQUIRE=$require command ssh "$@"
}
alias ssh='ssh-enp'
function ssh-enp-add() {
  local require=never
  ! ssh-add-has "${@: -1}" && enp init && require=force
  SSH_ASKPASS=enpass-askpass SSH_ASKPASS_REQUIRE=$require ssh-add-once "$@"
}
alias ssh-add='ssh-enp-add'
fi #enpass-askpass

fi #enpasscli
