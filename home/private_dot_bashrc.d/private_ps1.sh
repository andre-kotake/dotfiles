# # This script sets a custom Bash prompt (PS1) using an associative array.
# # The prompt includes information such as the current time, status of screen sessions,
# # running and stopped jobs, user information, hostname, current directory, and Git status.
#
# # Get the colored username
# __ps1_username() {
#   local color
#
#   if [[ $UID -eq 0 ]]; then
#     if [[ $USER != "$(logname)" ]]; then
#       color="\[\e[00;31m\]" # Red for root user not using sudo
#     elif [[ $SUDO_USER == "" ]]; then
#       color="\[\e[01;31m\]" # Bold Red for root user using sudo
#     else
#       color="\[\e[01;33m\]" # Bold Yellow for root user logged in normally
#     fi
#   else
#     if [[ $USER == "$(logname)" ]]; then
#       color="\[\e[00;32m\]" # Green for regular user logged in normally
#     else
#       color="\[\e[00;33m\]" # Yellow for regular user not logged in normally
#     fi
#   fi
#
#   printf "%s" "${color}\u"
# }
#
# # Get the hostname only when SSH
# __ps1_hostname() {
#   local color
#   if [[ $SSH_CLIENT != "" ]] || [[ $SSH2_CLIENT != "" ]]; then
#     color="\[\e[00;33m\]" # Yellow for SSH sessions
#   else
#     color="\[\e[00;32m\]" # Green for local sessions
#   fi
#   printf "%s" "${color}\h" # Yellow for SSH sessions
# }
#
# # Get the count of detached screen sessions
# __ps1_detached_screens() {
#   local count
#   count=$(screen -ls | grep -c Detach)
#   if [ "$count" -ne 0 ]; then
#     printf "%s %s" "\[\e[00;34m\]" "$count" # Blue for detached screens
#   fi
# }
#
# # Get the count of running jobs
# __ps1_running_jobs() {
#   local count
#   count=$(jobs -r | wc -l)
#   if [ "$count" -ne 0 ]; then
#     printf "%s %s" "\[\e[00;33m\]" "$count" # Yellow for running jobs
#   fi
# }
#
# # Get the count of stopped jobs
# __ps1_stopped_jobs() {
#   local count
#   count=$(jobs -s | wc -l)
#
#   if [ "$count" -ne 0 ]; then
#     printf "%s %s" "\[\e[00;31m\]" "$count" # Red for stopped jobs
#   fi
# }
#
# # Get the current directory color
# __ps1_dir_color() {
#   local color
#   if [[ -w $PWD ]]; then
#     color="\x01\e[01;34m\x02" # Blue for writable directory
#   else
#     color="\x01\e[01;31m\x02" # Red for non-writable directory
#   fi
#   printf "$color"
# }
#
# # Git status
# __ps1_git_status() {
#   local color
#   if [[ -n $(git status -s 2>/dev/null) ]]; then
#     color="\001\e[01;31m\002" # Red if there are changes
#   else
#     color="\001\e[01;32m\002" # Green for non-writable directory
#   fi
#
#   local branch="$(git branch --color=never 2>/dev/null \
#     | grep '*' \
#     | sed 's/* \(.*\)/ (\1\)/')"
#
#   printf "$color%s" "$branch"
# }
#
# # Append the color based on the last command's exit status
# __ps1_last_command_status_color() {
#   local color
#   if [[ $? == "0" ]]; then
#     color="\x01\e[01;32m\x02" # Green
#   else
#     color="\x01\e[01;31m\x02" # Red
#   fi
#   printf "%s" "$color"
# }
#
# # Build the PS1 prompt by concatenating all parts
# PS1="\n"
# # PS1+="${prompt_parts[detached_screens]} "
# # PS1+="${prompt_parts[running_jobs]} "
# # PS1+="${prompt_parts[stopped_jobs]} "
# PS1+="$(__ps1_username)"
# # PS1+="\[\e[00;36m\]@" # The "@" symbol (cyan)
# # PS1+="$(__ps1_hostname)"
# PS1+="\[\e[00m\]:"
# PS1+='$(__ps1_dir_color)'"\w"
# PS1+='$(__ps1_git_status)'
# PS1+="\[\e[00m\]\n\$ "
#
# export PS1

# PROMPT_COMMAND='PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"'

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

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

ALERT=${BWhite}${On_Red} # Bold White on red background

echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\
- DISPLAY on ${BRed}$DISPLAY${NC}"
date

if [ -x /usr/games/fortune ]; then
  /usr/games/fortune -s # Makes our day a bit more fun.... :-)
fi

function _exit() { # Function to run upon exit of shell.
  echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT

#-------------------------------------------------------------
# Shell Prompt - for many examples, see:
#       http://www.debian-administration.org/articles/205
#       http://www.askapache.com/linux/bash-power-prompt.html
#       http://tldp.org/HOWTO/Bash-Prompt-HOWTO
#       https://github.com/nojhan/liquidprompt
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    Green     == machine load is low
#    Orange    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Green     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').

# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
  CNX=${Green} # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
  CNX=${ALERT} # Connected on remote machine, not via ssh (bad).
else
  CNX=${BCyan} # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
  SU=${Red} # User is root.
elif [[ ${USER} != $(logname) ]]; then
  SU=${BRed} # User is not login user.
else
  SU=${BCyan} # User is normal (well ... most of us are).
fi

NCPU=$(grep -c 'processor' /proc/cpuinfo) # Number of CPUs
SLOAD=$((100 * ${NCPU}))                  # Small load
MLOAD=$((200 * ${NCPU}))                  # Medium load
XLOAD=$((400 * ${NCPU}))                  # Xlarge load

# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load() {
  local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
  # System load of the current host.
  echo $((10#$SYSLOAD)) # Convert to decimal.
}

# Returns a color indicating system load.
function load_color() {
  local SYSLOAD=$(load)
  if [ ${SYSLOAD} -gt ${XLOAD} ]; then
    echo -en ${ALERT}
  elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
    echo -en ${Red}
  elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
    echo -en ${BRed}
  else
    echo -en ${Green}
  fi
}

# Returns a color according to free disk space in $PWD.
function disk_color() {
  if [ ! -w "${PWD}" ]; then
    echo -en ${Red}
    # No 'write' privilege in the current directory.
  elif [ -s "${PWD}" ]; then
    local used=$(command df -P "$PWD" \
      | awk 'END {print $5} {sub(/%/,"")}')
    if [ ${used} -gt 95 ]; then
      echo -en ${ALERT} # Disk almost full (>95%).
    elif [ ${used} -gt 90 ]; then
      echo -en ${BRed} # Free disk space almost gone.
    else
      echo -en ${Green} # Free disk space is ok.
    fi
  else
    echo -en ${Cyan}
    # Current directory is size '0' (like /proc, /sys etc).
  fi
}

# Returns a color according to running/suspended jobs.
function job_color() {
  if [ $(jobs -s | wc -l) -gt "0" ]; then
    echo -en ${BRed}
  elif [ $(jobs -r | wc -l) -gt "0" ]; then
    echo -en ${BCyan}
  fi
}

# Adds some text in the terminal frame (if applicable).

# Now we construct the prompt.
# PROMPT_COMMAND="history -a"
case ${TERM} in
  *term | xterm-256color | rxvt | linux)
    PS1=""
    # PS1="\[\$(load_color)\][\A\[${NC}\] "
    # Time of day (with load info):
    # PS1="\[\$(load_color)\][\A\[${NC}\] "
    # User@Host (with connection type info):
    PS1=${PS1}"[\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] "
    # PWD (with 'disk space' info):
    PS1=${PS1}"\[\$(disk_color)\]\w\[${NC}\]] "
    # Prompt (with 'job' info):
    PS1=${PS1}"\[\$(job_color)\]\n>\[${NC}\] "
    # Set title of current xterm:
    PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"
    PS1="\n${PS1}"
    ;;
  *)
    PS1="\n(\A \u@\h \W)\n> " # --> PS1="(\A \u@\h \w) > "
    # --> Shows full pathname of current dir.
    ;;
esac
