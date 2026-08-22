#!/usr/bin/env bash
set -euo pipefail

token_dir="${XDG_CONFIG_HOME:-$HOME/.config}/gh/tokens"
args=("$@")

try_gh() {
  local owner="${1:-}"
  (( $# == 0 )) && owner="public"
  [[ -n "$owner" ]] || return 1
  if [[ "$owner" == */* ]]; then
    owner="$(extract_owner "$owner")" || return 1
  fi
  owner="${owner,,}" # lowercase
  [[ -r "$token_dir/$owner" ]] || return 1
  GH_TOKEN="$(<"$token_dir/$owner")"
  export GH_TOKEN
  exec /usr/bin/gh "${args[@]}"
}

extract_owner() {
  local arg="$1"
  # ignore likely free-form text args
  [[ "$arg" == *[[:space:]]* ]] && return 1
  # normalize common gh repository argument forms
  arg="${arg#--repo=}"
  arg="${arg#-R=}"
  arg="${arg#-R}"
  arg="${arg#https://github.com/}"
  arg="${arg#http://github.com/}"
  arg="${arg#git@github.com:}"
  arg="${arg#github.com/}"
  arg="${arg#/repos/}"
  arg="${arg#repos/}"
  arg="${arg%.git}"
  arg="${arg#/}"
  arg="${arg%/}"
  # OWNER/REPO shaped value is required
  [[ "$arg" == */* ]] || return 1
  echo "${arg%%/*}"
}

# check explicit owner/repo selectors
for ((i = 0; i < ${#args[@]}; i++)); do
  case "${args[$i]}" in
    --owner)            try_gh "${args[$((i + 1))]:-}" || try_gh ;;
    --owner=*)          try_gh "${args[$i]#--owner=}"  || try_gh ;;
    -R|--repo)          try_gh "${args[$((i + 1))]:-}" || try_gh ;;
    -R=*|--repo=*|-R?*) try_gh "${args[$i]}"           || try_gh ;;
  esac
done

# fallback to scanning repository-like args
for arg in "${args[@]}"; do
  try_gh "$arg" || continue
done

try_gh
