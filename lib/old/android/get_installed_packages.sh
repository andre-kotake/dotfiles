get_installed() {
mapfile -t packages < <(pacman -Q --quiet)
}
