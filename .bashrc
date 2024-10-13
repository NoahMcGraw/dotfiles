#!/usr/bin/env bash

if [ -t 1 ]
then
  ### MORE SENSIBLE BASH
  bind "set completion-ignore-case on"
  bind "set completion-map-case on"
  bind "set show-all-if-ambiguous on"

  bind 'TAB:menu-complete'
fi

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=100000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:x:clear"

# Useful timestamp format
HISTTIMEFORMAT='%F %T '

shopt -s autocd
shopt -s dirspell
shopt -s cdspell

# get colors working in bash
export TERM=xterm-256color

# get colors working in tmux
alias tmux="TERM=xterm-256color tmux"
alias x="exit"

export VISUAL="vim"
export EDITOR="$VISUAL"
export PATH="$PATH:$HOME/bin:$HOME/.scripts"
export PATH="$PATH:$HOME/.local/bin"

alias ls="ls --group-directories-first --color=tty"
alias ll="ls -A"

[ -x "$(command -v rg)" ] && export FZF_DEFAULT_COMMAND='rg --files'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"

# echo "$(__git_ps1)"
source ~/.git-prompt.sh
source ~/.git-completion.bash
PROMPT_COMMAND='__git_ps1 "\w" "\\\$ "'

# Record each line as it gets issued
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


