# shellcheck shell=sh
is_root() {
  [ "$(id -u)" -eq 0 ]
}

needs_sudo() {
  [ "$1" != "termux" ] && ! is_root
}

require_sudo() {
  if ! command -v sudo >/dev/null 2>&1; then
    log_error "sudo is required but not installed"
    exit 1
  fi
}

run_as_root() {
  os=$1
  shift

  if needs_sudo "$os"; then
    require_sudo
    sudo "$@"
  else
    "$@"
  fi
}
