# Set GnuPG home directory
export GNUPGHOME="${HOME}/.config/gnupg"

# Communicate with gpg-agent instead of the default ssh-agent.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK
fi

# Configure pinentry to use the correct TTY
export GPG_TTY=$(tty)

# Get keygrip
# _keygrip=$(gpg --with-colons --list-secret-key | awk -F: '$1=="ssb" && $12=="a" {line=FNR+2} $1=="grp" && FNR=line {print $10}')

# Refresh the TTY in case user has switched into an X session as stated in https://man.archlinux.org/man/gpg-agent.1
# gpg-connect-agent updatestartuptty "keyattr $_keygrip Use-for-ssh: true" /bye >/dev/null 2>&1

# refresh tty for gpg-agent
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

# unset _keygrip
