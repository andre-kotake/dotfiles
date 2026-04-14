check_package() {
  dpkg -s "$1" >/dev/null 2>&1
  return
}

install_packages() {
  isRoot="$1"
  shift
  if [ "$isRoot" -eq 0 ]; then
    sudo apt install -y "$@"
  else
    apt install -y "$@"
  fi
}
