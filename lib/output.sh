# Normal Colors
Black='\e[0;30m'  # Black
Red='\e[0;31m'    # Red
Green='\e[0;32m'  # Green
Yellow='\e[0;33m' # Yellow
Blue='\e[0;34m'   # Blue
Purple='\e[0;35m' # Purple
Cyan='\e[0;36m'   # Cyan
White='\e[0;37m'  # White

# Bold
BBlack='\e[1;30m'  # Black
BRed='\e[1;31m'    # Red
BGreen='\e[1;32m'  # Green
BYellow='\e[1;33m' # Yellow
BBlue='\e[1;34m'   # Blue
BPurple='\e[1;35m' # Purple
BCyan='\e[1;36m'   # Cyan
BWhite='\e[1;37m'  # White

# Background
On_Black='\e[40m'  # Black
On_Red='\e[41m'    # Red
On_Green='\e[42m'  # Green
On_Yellow='\e[43m' # Yellow
On_Blue='\e[44m'   # Blue
On_Purple='\e[45m' # Purple
On_Cyan='\e[46m'   # Cyan
On_White='\e[47m'  # White

NC="\e[m" # Color Reset

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

#
repeat() {
  local code="$1"
  local count="${2:-$(term_width)}"
  printf '%.0s'"$code" $(seq 1 "$count")
}

script_header() {
  local text="$1"
  echo -en "${NC}${White}"
  echo -e "$text"
  repeat '\u2550'
  echo -e "${NC}"
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
