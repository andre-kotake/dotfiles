# chezmoi:template:left-delimiter="# {{"
#!# {{ lookPath "sh" }}
set -eu

# Source helper scripts
# {{ "." }} # {{ joinPath .scriptLib "print.sh" }}
# {{ "." }} # {{ joinPath .scriptLib "trap.sh" }}

# Show current script name
log_script

# Main script body
