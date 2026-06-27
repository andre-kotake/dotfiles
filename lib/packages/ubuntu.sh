# shellcheck shell=sh
check_package() {
  dpkg -s "$1" >/dev/null 2>&1
  return
}

install_packages() {
  run_as_root "$CURRENT_OS" apt-get install -y "$@"
}
