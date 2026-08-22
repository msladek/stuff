#!/usr/bin/env bash
set -euo pipefail

token_dir="${XDG_CONFIG_HOME:-$HOME/.config}/gh/tokens"

# Tokens are file-backed, so there is nothing to store or erase.
[[ "${1:-}" == "get" ]] || exit 0

protocol=""
host=""
path=""

while IFS='=' read -r key value; do
  case "$key" in
    protocol) protocol="$value" ;;
    host)     host="$value" ;;
    path)     path="$value" ;;
  esac
done

[[ "$protocol" == "https" ]] || exit 0
[[ "$host" == "github.com" ]] || exit 0

path="${path#/}"

if [[ "$path" == */* ]]; then
  owner="${path%%/*}"
  owner="${owner,,}"
else
  owner="public"
fi

token_file="$token_dir/$owner"
[[ -r "$token_file" ]] || token_file="$token_dir/public"
[[ -r "$token_file" ]] || exit 1

printf 'username=x-access-token\n'
printf 'password=%s\n\n' "$(<"$token_file")"
