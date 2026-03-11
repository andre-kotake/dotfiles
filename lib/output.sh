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

info() {
  printf "%s%s\n" "$1" "$C_RESET" >&2
}

success() {
  printf "%s%s%s\n" "$C_GREEN" "$1" "$C_RESET" >&2
}

warn() {
  printf "%s%s%s\n" "$C_YELLOW" "$1" "$C_RESET" >&2
}

error() {
  printf "%s%s%s\n" "$C_RED" "$1" "$C_RESET" >&2
}

line_break() {
  printf "\n"
}

term_width() {
  if [ -n "$COLUMNS" ]; then
    printf '%s' "$COLUMNS"
    return
  fi

  set -- $(stty size 2>/dev/null)
  if [ -n "$2" ]; then
    printf '%s' "$2"
    return
  fi

  printf '%s' 80
}

fill_line() {
  # $1 = character (default: -)
  char=${1:--}
  width=$(term_width)

  printf '%*s\n' "$width" '' | tr ' ' "$char"
}

center_text() {
  # $1 = text
  text=$1
  width=$(term_width)
  len=${#text}

  if [ "$len" -ge "$width" ]; then
    printf "%s\n" "$text"
    return
  fi

  pad=$(((width - len) / 2))
  printf "%*s%s\n" "$pad" '' "$text"
}

center_pad() {
  # $1 = text
  # $2 = padding char (default: -)

  text=$1
  char=${2:--}

  width=$(term_width)
  len=${#text}

  if [ "$len" -ge "$width" ]; then
    printf "%s\n" "$text"
    return
  fi

  total_pad=$((width - len - 2))
  left=$((total_pad / 2))
  right=$((total_pad - left))

  printf "%*s" "$left" '' | tr ' ' "$char"
  printf " %s " "$text"
  printf "%*s\n" "$right" '' | tr ' ' "$char"
}

section() {
  center_pad "$1" "="
}

script_name() {
  basename "$0"
}

# log levels
LOG_LEVEL_ERROR=0
LOG_LEVEL_WARN=1
LOG_LEVEL_INFO=2
LOG_LEVEL_DEBUG=3

LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}
LOG_QUIET=${LOG_QUIET:-0}

log_print() {
  level="$1"
  color="$2"
  tag="$3"
  msg="$4"

  [ "$LOG_QUIET" -eq 1 ] && [ "$level" -gt "$LOG_LEVEL_ERROR" ] && return
  [ "$level" -gt "$LOG_LEVEL" ] && return

  printf "%s[%s]%s %s\n" "$color" "$tag" "$C_RESET" "$msg" >&2
}

log_script() {
  printf "\n%s[*]%s %s\n" "$C_MAGENTA" "$C_RESET" "$(script_name)"
}

log_error() {
  log_print "$LOG_LEVEL_ERROR" "$C_RED" "ERROR" "$1"
}

log_warn() {
  log_print "$LOG_LEVEL_WARN" "$C_YELLOW" "WARN" "$1"
}

log_info() {
  log_print "$LOG_LEVEL_INFO" "$C_BLUE" "INFO" "$1"
}

log_ok() {
  log_print "$LOG_LEVEL_INFO" "$C_GREEN" "OK" "$1"
}

log_debug() {
  log_print "$LOG_LEVEL_DEBUG" "$C_CYAN" "DEBUG" "$1"
}

die() {
  log_error "$1"
  exit 1
}
