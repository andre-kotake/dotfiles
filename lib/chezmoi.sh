# shellcheck shell=sh
install_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    CHEZMOI_BIN=$(command -v chezmoi)
    return 0
  fi

  bin_dir="${HOME}/.local/bin"
  CHEZMOI_BIN="${bin_dir}/chezmoi"

  if command -v "$CHEZMOI_BIN" >/dev/null 2>&1; then
    return 0
  fi

  log_info "Installing ${S_HL}chezmoi$C_RESET to ${S_HL}$CHEZMOI_BIN$C_RESET"

  mkdir -p "$bin_dir" || return 1

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL get.chezmoi.io \
      | sh -s -- -b "$bin_dir" || return 1
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- get.chezmoi.io \
      | sh -s -- -b "$bin_dir" || return 1
  else
    log_error "${S_HL}chezmoi installation requires curl or wget"
    return 1
  fi

  [ -x "$CHEZMOI_BIN" ] || return 1

  return 0
}

init_chezmoi() {
  log_info "Initializing ${S_HL}chezmoi${C_RESET}..."
  source="$1"
  target="$2"

  CHEZMOI_BIN="${CHEZMOI_BIN:-chezmoi}"
  "$CHEZMOI_BIN" init \
    --source "$source" \
    --destination "$target" \
    \
    --apply --exclude scripts --force \
    ||
    # --config-path "$target/.config" \
    return 1

  log_info "Source path: $S_HL$("$CHEZMOI_BIN" source-path)"
  log_info "Target path: $S_HL$("$CHEZMOI_BIN" target-path)"
  log_ok "$S_HL$("$CHEZMOI_BIN" --version)"

  return 0
}
