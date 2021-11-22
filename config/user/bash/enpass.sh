if command -v enpasscli+ >/dev/null; then
alias enpls='enp list'
alias enpsh='enp show'
alias enpcp='enp copy'
function enp() {
  [ -z "$enp_pin" ] \
    && read -s -p "Enter PIN (or omit): " enp_pin && echo \
    && export enp_pin
  export pbkdf2_iter="1000000"
  enpasscli+ "$@" \
    || unset enp_pin
  return $?
}
fi
