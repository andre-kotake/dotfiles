# Foreground (text) color code
declare -A fg=(
  ["black"]="\e[0;30m"
  ["red"]="\e[0;31m"
  ["bred"]="\e[0;91m"
  ["green"]="\e[0;32m"
  ["bgreen"]="\e[0;92m"
  ["yellow"]="\e[0;33m"
  ["blue"]="\e[0;34m"
  ["magenta"]="\e[0;35m"
  ["cyan"]="\e[0;36m"
  ["white"]="\e[0;37m"
  ["bwhite"]="\e[0;97m"
  ["reset"]="\e[0m"
)

# Background color codes
declare -A bg=(
  ["black"]="\e[0;40m"
  ["red"]="\e[0;41m"
  ["green"]="\e[0;42m"
  ["yellow"]="\e[0;43m"
  ["blue"]="\e[0;44m"
  ["magenta"]="\e[0;45m"
  ["cyan"]="\e[0;46m"
  ["white"]="\e[0;47m"
  ["reset"]="\e[0m"
)

# Text style codes
declare -A st=(
  ["bold"]="\e[1m"
  ["italic"]="\e[3m"
  ["underline"]="\e[4m"
  ["dim"]="\e[2m"
  ["reset"]="\e[22m"
)

# Get terminal width
term_width() {
  stty size | awk '{print $2}'
}

dimmed() {
  local style="${fg[blue]} ${fg[white]}${st[underline]}"
  local text="$1"
  printf "$style%s\e[0m\n" "$text"
}

info() {
  local style="${fg[magenta]}:: ${fg[reset]}"
  local text="$1"
  printf "$style%s\e[0m\n" "$text"
}

success() {
  local style="${fg[bgreen]}** ${fg[reset]}"
  local text="$1"
  printf "$style%s\e[0m\n" "$text"
}

error() {
  local style="${fg[bred]}!! ${st[bold]}Error: ${fg[reset]}"
  local text="$1"
  printf "$style%s\e[0m\n" "$text"
}
# Prints title
title() {
  local style="${fg[blue]}${st[bold]}${st[underline]}"
  local text="$1"
  printf "$style%-*s\e[0m\n" "$(term_width)" "$text"
}

# Fill the terminal width with asterisks or specified char
fill_width() {
  printf '%*s\n' "$(term_width)" '' | tr ' ' "${1:-*}"
}

# Center a message in the terminal
center() {
  local msg="$1"
  local pad=$(((${#msg} + $(term_width)) / 2))
  printf '%*s\n' "$pad" "$msg"
}
