# Set GnuPG home directory
export GNUPGHOME="${HOME}/.config/gnupg"

# Communicate with gpg-agent instead of the default ssh-agent.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK
fi

# Configure pinentry to use the correct TTY
export GPG_TTY
GPG_TTY=$(tty)

# refresh tty for gpg-agent
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
