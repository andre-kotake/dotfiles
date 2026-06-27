bind Space:magic-space # Enable history expansion with space

set -o noclobber # Use `>|` to force redirection to an existing file

shopt -s checkwinsize         # Update window size after every command
shopt -s globstar 2>/dev/null # Turn on recursive globbing (enables ** to recurse all directories)
shopt -s nocaseglob           # Case-insensitive globbing (used in pathname expansion)
shopt -s histappend           # Append to the history file, don't overwrite it
shopt -s cmdhist              # Save multi-line commands as one command
shopt -s autocd 2>/dev/null   # Prepend cd to directory names automatically
shopt -s dirspell 2>/dev/null # Correct spelling errors during tab-completion
shopt -s cdspell 2>/dev/null  # Correct spelling errors in arguments supplied to cd
shopt -u mailwarn             # Disable email check

unset MAILCHECK # Don't want my shell to warn me of incoming mail.

# shopt -s cdable_vars
# export dotfiles="$HOME/repositories/dotfiles"
