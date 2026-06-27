# shellcheck shell=sh
check_package() {
  if [ "$TERMUX_MAIN_PACKAGE_FORMAT" = "pacman" ]; then
    pacman -Q "$1" >/dev/null 2>&1
  else
    dpkg -s "$1" >/dev/null 2>&1
  fi
}

install_packages() {
  case "$TERMUX_MAIN_PACKAGE_FORMAT" in
    pacman)
      pacman -Sy --noconfirm --needed "$@"
      ;;
    *)
      pkg update -y
      pkg install -y "$@"
      ;;
  esac
}
