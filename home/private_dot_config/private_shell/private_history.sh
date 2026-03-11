export HISTFILE="${HOME}/.local/state/history"

if [ -n "$BASH_VERSION" ]; then
  export HISTSIZE=500000
  export HISTFILESIZE=100000
  export HISTCONTROL="erasedups:ignoreboth"
  export HISTIGNORE="&:[ ]*:exit:ls:ll:lt:l:bg:fg:history:clear"
  export HISTTIMEFORMAT='%F %T'

  export PROMPT_COMMAND="history -a ${PROMPT_COMMAND:+&& $PROMPT_COMMAND}"
fi

if [ -n "$ZSH_VERSION" ]; then
  HISTSIZE=500000
  SAVEHIST=100000

  setopt APPEND_HISTORY
  setopt SHARE_HISTORY
  setopt HIST_IGNORE_ALL_DUPS
  setopt HIST_REDUCE_BLANKS
fi
