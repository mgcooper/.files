# shellcheck shell=bash

#### .bash_profile

# Use .profile to expose environment variables outside of the bash shell

# Don't set PATH manually, only append to it to avoid removing system-defined paths.
# Apple's security-related paths are dynamically set and should not be overwritten.

# Ensure Homebrew is available before anything else
eval "$(/opt/homebrew/bin/brew shellenv)"

# Source the startup dotfiles
# shellcheck source-path=$HOME
# shellcheck disable=SC1090
for file in $HOME/.{exports,bashrc,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# User-specific environment and startup programs

# Adjust paths after sourcing .exports.
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"                # Pipx installs
export PATH="$HOME/bin:$PATH"                       # Custom utilities
# export PATH="$USER_SCRIPTS_PATH/gdal_scripts:$PATH" # Custom utilities

# Source completions for bash-completion@2
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

# Source all completions from bash-completion@1 (some tools still install here)
# If completions for specific tools break, re-source individual scripts after this block
if type brew &>/dev/null; then
	for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
		[[ -r "$COMPLETION" ]] && . "$COMPLETION"
	done
fi

# Git completions used to break due to Hub; if needed, re-source them here:
# [[ -r "$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash" ]] && . "$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash"
# [[ -r "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh" ]] && . "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh"

# Source custom completions. This happens in the loop, but keep this as a reminder of where they live:
##[[ -r "$(brew --prefix)/etc/bash_completion.d/custom-completion.sh" ]] && . "$HOME/bin/custom-completion"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/Users/mattcooper/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/Users/mattcooper/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Autocompletion for conda/mamba
if [ -f "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh" ]; then
    . "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh"
fi


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

eval "$(starship init bash)"

# Delete duplicate PATH entries
PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')
PYTHONPATH=$(printf "%s" "$PYTHONPATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')

# Exports that need to happen here rather than in .exports
# none currently

