# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
export EDITOR='/usr/bin/nvim'
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

PATH="$HOME/bin:$HOME/.local/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin"
PATH="$XDG_DATA_HOME/cargo/bin:$PATH"
PATH="$HOME/.pyenv/bin:$PATH"
PATH="$HOME/.local/scripts:$PATH"

# Settings for a cleaner $HOME dir
export HISTFILE="$XDG_STATE_HOME"/bash/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GTK2_RC_FILE=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export NODE_REPL_HISTORY="$XDG_STATE_HOME"/node_repl_history
export OPAMROOT="$XDG_DATA_HOME"/opam
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
export W3M_DIR="$XDG_DATA_HOME"/w3m
export WINEPREFIX="$XDG_DATA_HOME"/wine

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
