# shellcheck shell=sh
export GNUPGHOME="${HOME}/.config/gnupg"

ensure_line_in_file() {
  file=$1
  line=$2

  touch "$file" || return 1
  chmod 600 "$file" || return 1

  if ! grep -qxF "$line" "$file"; then
    printf '%s\n' "$line" >>"$file" || return 1
  fi
}

setup_gpg_home() {
  log_info "Setting up GPG home at $GNUPGHOME"
  mkdir -p "$GNUPGHOME" || return 1
  chmod 700 "$GNUPGHOME" || return 1
}

install_gpg_secrets() {
#if gpg --list-secret-keys >/dev/null 2>&1; then
#    return 0
#fi
  if [ ! -f "$HOME/secret-subkeys.asc" ] || [ ! -f "$HOME/ownertrust" ]; then
    log_error "Missing GPG secret files: secret-subkeys.asc or ownertrust"
    return 1
  fi

  log_info "Importing secret subkeys"
  gpg --import "$HOME/secret-subkeys.asc" >/dev/null 2>&1 || return 1

  log_info "Importing owner trust"
  gpg --import-ownertrust "$HOME/ownertrust" >/dev/null 2>&1 || return 1
}

configure_gpg_agent() {
  log_info "Configuring gpg-agent for SSH support"

  ensure_line_in_file \
    "$GNUPGHOME/gpg-agent.conf" \
    "enable-ssh-support" || return 1

gpgconf --reload gpg-agent >/dev/null 2>&1 || {
    gpgconf --launch gpg-agent >/dev/null 2>&1
}
}

activate_gpg_ssh_bridge() {
  log_info "Activating SSH agent bridge via gpg-agent"

  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK

  GPG_TTY="$(tty)"
  export GPG_TTY
}

get_auth_keygrip() {
  gpg --with-colons --list-secret-keys --with-keygrip 2>/dev/null \
    | awk -F: '
    $1 == "ssb" { auth=($12 ~ /a/) }
    $1 == "grp" && auth { print $10; exit }
  '
}

ensure_gpg_ssh_key() {
  log_info "Ensuring SSH-enabled GPG key is registered"

  keygrip=$(get_auth_keygrip)

if [ -z "$keygrip" ]; then
    log_error "No authentication-capable subkey ([A]) found"
    return 1
  fi

  ensure_line_in_file "$GNUPGHOME/sshcontrol" "$keygrip" || return 1
}

ensure_connection_agent() {
  log_info "Checking gpg-agent connectivity"
  # Add this in fron of updatestartuptty if needed:
  #  "keyattr $keygrip Use-for-ssh: true"
  #  keygrip="$(get_auth_keygrip)"
  # [ "$keygrip" != "" ] || return 1
  # Refresh the TTY in case user has switched into an X session as stated in https://man.archlinux.org/man/gpg-agent.1
  if ! gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1; then
    log_error "gpg-agent is not responding"
    return 1
  fi
}

verify_gpg_ssh_agent() {
  if ! ssh-add -l >/dev/null 2>&1; then
    log_error "gpg-agent SSH interface not responding"
    return 1
  fi

  log_ok "GPG SSH agent is active"
}

setup_gpg_ssh_agent() {
  setup_gpg_home || return 1
  install_gpg_secrets || return 1
  configure_gpg_agent || return 1
  ensure_gpg_ssh_key || return 1
  ensure_connection_agent || return 1
  activate_gpg_ssh_bridge || return 1
  verify_gpg_ssh_agent || return 1
}
