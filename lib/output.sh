#shellcheck disable=2034
if [ -t 1 ]; then
  C_RESET=$(printf '\033[0m')
  C_BOLD=$(printf '\033[1m')

  C_BLACK=$(printf '\033[30m')
  C_RED=$(printf '\033[31m')
  C_GREEN=$(printf '\033[32m')
  C_YELLOW=$(printf '\033[33m')
  C_BLUE=$(printf '\033[34m')
  C_MAGENTA=$(printf '\033[35m')
  C_CYAN=$(printf '\033[36m')
  C_WHITE=$(printf '\033[37m')

else
  C_RESET=''
  C_BOLD=''

  C_BLACK=''
  C_RED=''
  C_GREEN=''
  C_YELLOW=''
  C_BLUE=''
  C_MAGENTA=''
  C_CYAN=''
  C_WHITE=''

fi

color_print() {
  # $1 = color
  # $2 = text
  printf "%s%s%s\n" "$1" "$2" "$C_RESET"
}

bold_print() {
  color_print "$C_BOLD" "$1"
  # printf "%s%s%s\n" "$C_BOLD" "$1" "$C_RESET"
}

success() {
  printf "%s%s%s\n" "$C_GREEN" "$1" "$C_RESET"
}

warn() {
  printf "%s%s%s\n" "$C_YELLOW" "$1" "$C_RESET"
}

error() {
  printf "%s%s%s\n" "$C_RED" "$1" "$C_RESET"
}
