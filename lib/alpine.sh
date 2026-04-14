check_package() {
  apk info -e "$1" >/dev/null 2>&1
  return
}

install_packages() {
  isRoot="$1"
  shift
  if [ "$isRoot" -eq 0 ]; then
    sudo apk add --quiet --no-interactive "$@"
  else
    apk add --quiet --no-interactive "$@"
  fi
}
