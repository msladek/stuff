if command -v enpasscli+ >/dev/null; then

export pbkdf2_iter=1000000
export enp_pin_length=8
export enp_pin_timeout=300

alias enpls='enp list'
alias enpsh='enp show'
alias enpcp='enp copy'

if command -v enpass-askpin >/dev/null; then
function enp() {
  local pin="$enp_pin"
  [ "$1" = "rm" ] \
    && unset enp_pin \
    || pin="$(enpass-askpin)"
  enp_pin=$pin enpasscli+ "$@"
  local exit_code=$?
  [ $exit_code -eq 0 ] && [ -z "$enp_pin" ] && [ -n "$pin" ] \
    && export enp_pin=$pin \
    && trap 'unset enp_pin' SIGUSR1 \
    && local current_pid=$BASHPID \
    && (( sleep $enp_pin_timeout; kill -SIGUSR1 $current_pid ) & ) > /dev/null 2>&1
  return $exit_code
}

if command -v enpass-askpass >/dev/null; then
function ssh() {
  local require=never
  enp check && require=force
  SSH_ASKPASS=enpass-askpass SSH_ASKPASS_REQUIRE=$require command ssh "$@"
}
fi #enpass-askpass

fi #enpass-askpin

fi #enpasscli+
