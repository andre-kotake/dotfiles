# shellcheck shell=sh
detect_os() {
  if [ -n "$TERMUX_VERSION" ]; then
    printf "%s\n" android
    return
  fi

  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    printf '%s\n' "$ID"
    return
  fi

  printf '%s\n' unknown
}

normalize_os() {
  case "$1" in
    opensuse* | suse | sled | sles)
      echo "opensuse"
      ;;
    *)
      echo "$1"
      ;;
  esac
}
