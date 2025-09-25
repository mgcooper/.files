# ~/.zshrc — Zsh interactive config
# shellcheck shell=zsh

# Homebrew shell env (adds Homebrew binaries to PATH)
eval "$(${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew shellenv)"

# ----------------
# Set Zsh options
# ----------------
### History Behavior
setopt append_history         # Save history after command finishes (not live)
setopt hist_ignore_space      # Ignore commands starting with a space
setopt hist_ignore_all_dups   # Remove older duplicate commands in history
setopt hist_reduce_blanks     # Remove superfluous whitespace from commands
setopt hist_verify            # Don't auto-execute history entries—edit first
setopt hist_save_no_dups      # Don't write duplicate commands to history file
setopt hist_find_no_dups      # Skip duplicates when searching history
setopt extended_history       # Record timestamp and duration with each command
unsetopt share_history        # Prevent history syncing between terminals
unsetopt inc_append_history   # Don't write to history immediately

### Directory Navigation
setopt autocd                 # Type dir name to `cd` into it
setopt cdable_vars            # Allow `cd $VAR` if VAR is a path

### Shell Interaction & Safety
setopt correct                # Suggest command corrections
setopt interactive_comments   # Allow comments in interactive shell
setopt prompt_subst           # Enable prompt variable substitution
setopt noclobber              # Prevent overwriting files with `>`
setopt rm_star_wait           # Delay before executing `rm *` to prevent accidents
setopt no_beep                # Disable terminal bell


# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
zstyle ':zim:termtitle' format '%1~'

# Enable double-dot path expansion via Zim input module
zstyle ':zim:input' double-dot-expand yes

# From conda-zsh-completions _conda file (should go in zprofile but keep here w/others)
zstyle ':completion::complete:*' use-cache 1
zstyle ":conda_zsh_completion:*" use-groups true

# git module config - set a custom prefix for git aliases
# commented out until compared with custom git aliases in .aliases
# zstyle ':zim:git' aliases-prefix 'g'

# zsh-autosuggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'  # default muted grey

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ----------------------
# Initialize Zim modules
# ----------------------
export ZIM_HOME="${ZDOTDIR:-$HOME}/.zim"
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

# zsh-history-substring-search bindings
zmodload -F zsh/terminfo +p:terminfo

# Bind up/down keys and alternatives for history substring search
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
unset key

# ---------------
# Starship prompt
# ---------------
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# ----------------------------
# Export aliases and functions
# ----------------------------
[[ -f $HOME/.aliases ]] && source "$HOME/.aliases"
[[ -f $HOME/.functions ]] && source "$HOME/.functions"

# ----------------
# pipx completions
# ---------------- 
# ensure this is after zim init
eval "$(register-python-argcomplete pipx)"

# --------------
# Clean up PATHs
# --------------
PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')
PYTHONPATH=$(printf "%s" "$PYTHONPATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')

# ------------------------
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup
# <<< mamba initialize <<<
# ------------------------
