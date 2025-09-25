# shellcheck shell=bash

#### .bashrc (shell-specific configuration)
#### Use this to set (not export) shell variables, e.g. PS1, IFS, HISTFILE, and options (shopt)

# ---- Source system-wide profiles
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# ---- HISTORY
# HISTFILE=$HOME/.bash_history # default
# HISTCONTROL=ignoredups # remove duplicates
HISTCONTROL=ignoreboth:erasedups # remove duplicates and lines beginning with space, and 
HISTIGNORE="&:ls:[bf]g:pwd:exit:cd .."
HISTSIZE=30000 # set history length
HISTFILESIZE=30000 # set history length

# Update the history after every command execution to enable shared history between sessions 
# (note: neither of these work as expected, need to switch to zsh or fish)
# PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ---- SHOPT
shopt -s histappend # append to the history file, don't overwrite it
shopt -s cmdhist # Store multiline commands as one line.
shopt -s checkwinsize # resize the window when output
shopt -s cdspell # Autocorrect typos in path names when using `cd`
##shopt -s dirspell # Spellcheck directories
# shopt -s nocaseglob; #  Case-insensitive globbing (used in pathname expansion)
# shopt -s autocd # cd into directories w/o typing 'cd' first (interactive shells only)
shopt -s cdable_vars # If set, an argument to the cd builtin command that is not a directory is assumed to be the name of a variable whose value is the directory to change to.
