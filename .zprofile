# ~/.zprofile — Zsh login config
# shellcheck shell=zsh

# Homebrew shell env (adds Homebrew binaries to PATH)
eval "$(${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew shellenv)"

# Export environment variables and functions
[[ -f $HOME/.exports ]] && source "$HOME/.exports"

# Adjust paths after sourcing .exports.
export PATH="$PATH:$HOME/.local/bin"                			# Pipx installs
export PATH="$PATH:$HOME/bin"                       			# Custom utilities
# export PATH="$PATH:$USER_SCRIPTS_PATH/gdal_scripts" 			# Custom gdal utilities
export PATH="$PATH:$HOME/.gem/ruby/2.6.0/bin"           		# Ruby gems, specifically for TextMate Markdown Bundle
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"	# Gnu coreutils, see brew install caveat copied below

# brew install coreutils caveat:
# Commands also provided by macOS and the commands dir, dircolors, vdir have been installed with the prefix "g".
# If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
#   PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"