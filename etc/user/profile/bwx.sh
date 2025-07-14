if command -v bwx >/dev/null; then

if command -v bwx-askpass >/dev/null; then
function ssh() { ssh-bwx "$@"; }
function ssh-bwx() {
  local require=never
  ! ssh-add-has "${@: -1}" && bwx unlock && require=force
  SSH_ASKPASS=bwx-askpass SSH_ASKPASS_REQUIRE=$require command ssh "$@"
}
function ssh-add() { ssh-bwx-add "$@"; }
function ssh-bwx-add() {
  local require=never
  ! ssh-add-has "${@: -1}" && bwx unlock && require=force
  SSH_ASKPASS=bwx-askpass SSH_ASKPASS_REQUIRE=$require ssh-add-once "$@"
}
fi #bwx-askpass

fi #bwx
