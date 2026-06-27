#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH=$(cd -- "$(dirname -- "$0")") && pwd)"
SCRIPT_LIB_DIR="$SCRIPT_DIR/lib"

# Source lib scripts
. "$SCRIPT_LIB_DIR/trap.sh"
. "$SCRIPT_LIB_DIR/print.sh"
. "$SCRIPT_LIB_DIR/os.sh"
. "$SCRIPT_LIB_DIR/sudo.sh"
. "$SCRIPT_LIB_DIR/gnupg.sh"
. "$SCRIPT_LIB_DIR/chezmoi.sh"

# Helpers
detect_current_os() {
  normalize_os "$(detect_os)"
}

validate_os() {
  os=$1

  [ "$os" != "unknown" ] || {
    log_error "Unsupported OS: %s" "$os"
    return 1
  }

  [ -f "$SCRIPT_LIB_DIR/packages/$os.sh" ] || {
    log_error "No package handler found for OS: %s" "$os"
    return 1
  }
}

install_packages_for_os() {
  os=$1

  # shellcheck source=./lib/packages/termux.sh
  . "$SCRIPT_LIB_DIR/packages/$os.sh"

  install_packages \
    git \
    wget \
    curl \
    vim \
    gnupg \
    openssh
}

############################################################
# Main
############################################################
spinner() {
  pid=$1
  msg=$2
  spin="|/-\\"
  # spin='⠁⠂⠄⠂'
  # spin='◴◷◶◵'
  # spin='◐◓◑◒'

  while kill -0 "$pid" 2>/dev/null; do
    c=${spin%"${spin#?}"}
    printf '\r%s [%s]' "$msg" "$c"
    spin=${spin#?}$c
    sleep 0.1
  done
}

run_step() {
  msg_start="==> $1"
  shift

  printf '%s' "$msg_start"

  "$@" >/dev/null 2>&1 &
  pid=$!

  spinner "$pid" "$msg_start"

  wait "$pid"
  status=$?

  clear_line

  if [ "$status" -eq 0 ]; then
    printf "%s... ${C_GREEN}OK$C_RESET\n" "$msg_start"
  else
    printf "%s... ${C_RED}FAILED$C_RESET\n" "$msg_start"
    return "$status"
  fi
}

main() {
  clean

  current_os=$(detect_current_os)
  validate_os "$current_os" || return 1

  section "Installing packages"
  log_info "Detected OS: $S_HL$current_os"
  install_packages_for_os "$current_os" || return 1

  line_break
  section "Configuring GPG SSH Agent"
  setup_gpg_ssh_agent || return 1

  line_break
  section "Setup chezmoi"
  if [ ! "$os" = "termux" ]; then
    install_chezmoi || return 1
  else
    log_info "Installing ${S_HL}chezmoi$C_RESET"
    install_packages chezmoi >/dev/null 2>&1 || return 1
  fi
  init_chezmoi "$SCRIPT_DIR" "$HOME" || return 1

  return 0
}

main "$@"
