#!/usr/bin/env bash
set -euo pipefail

readonly cli="$HOME/.npm-global/bin/playwright-cli"
readonly config="$HOME/.playwright/cli.config.json"
readonly tmpdir="$HOME/ws/tmp/playwright/runtime"
readonly allowed_commands=(
  open close
  goto go-back go-forward reload
  type click dblclick fill drag hover select check uncheck
  press keydown keyup mousemove mousedown mouseup mousewheel
  snapshot find eval highlight generate-locator
  dialog-accept dialog-dismiss resize screenshot pdf
  tab-list tab-new tab-close tab-select
  state-load
  cookie-list cookie-get cookie-set cookie-delete cookie-clear
  localstorage-list localstorage-get localstorage-set localstorage-delete localstorage-clear
  sessionstorage-list sessionstorage-get sessionstorage-set sessionstorage-delete sessionstorage-clear
  requests request request-headers request-body response-headers response-body route-list network-state-set console
)

die() {
  echo "playwright-cli: $*" >&2
  echo "playwright-cli: for unrestricted access use 'playwright-cli-x' instead" >&2
  exit 64
}

globals=()
while (( $# )); do
  case "$1" in
    --raw|--json|--help|--version|-s=*|--session=*) globals+=("$1"); shift ;;
    *) break ;;
  esac
done

command="${1:-}"
[[ -z "$command" ]] || shift

for arg in "$@"; do
  case "$arg" in
    --config|--config=*|--profile|--profile=*|--filename|--filename=*)
      die "option is disabled: $arg"
      ;;
  esac
done

allowed=false
[[ -n "$command" ]] || allowed=true
for allowed_command in "${allowed_commands[@]}"; do
  if [[ "$command" == "$allowed_command" ]]; then
    allowed=true
    break
  fi
done
"$allowed" || die "command is disabled: $command"

[[ "$command" == open ]] && set -- "$@" "--config=$config"
[[ -z "$command" ]] || set -- "$command" "$@"

TMPDIR="$tmpdir" exec "$cli" "${globals[@]}" "$@"
