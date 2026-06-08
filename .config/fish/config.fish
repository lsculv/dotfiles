set -g fish_greeting
set -gx EDITOR /usr/bin/nvim

fish_add_path -aP /home/lucas/.juliaup/bin

# XDG environment
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_STATE_HOME $HOME/.local/state
set -x XDG_CACHE_HOME $HOME/.cache

# Secrets (API keys) — kept out of version control; see .gitignore
if test -f $XDG_CONFIG_HOME/fish/secrets.fish
    source $XDG_CONFIG_HOME/fish/secrets.fish
end

# `bat`
set -x BAT_THEME base16

# GPG key entry via the terminal
set -x GPG_TTY (tty)

if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr -a fishcfg cd ~/.config/fish/

    # Common command aliases
    alias ls='command ls -lGhvX --group-directories-first --color=auto'
    alias la='command ls -lAGhvX --group-directories-first --color=auto'
    abbr -a open xdg-open
    abbr -a gs git status
    abbr -a fst head -n 1
    abbr -a lst tail -n 1

    # Config management
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

    # Neovim Configurations
    abbr -a vim nvim
    abbr -a vimrc cd ~/.config/nvim

    # fzf Configurations
    #set -x FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"
    if type -sq fzf
        source /usr/share/fzf/shell/key-bindings.fish
        fzf_key_bindings
    end
    # Search from the home directory, making sure we stay in the same directory
    # we were in if we exit early
    function ff;
        set last "$PWD"
        if test -n "$argv[1]"
            set directory "$argv[1]"
        else
            set directory "$HOME"
        end
        cd (fd --type d --exclude go . "$directory" | fzf --scheme path --bind tab:up,btab:down || printf '%s' "$last")
    end
    # Searches hidden files as well
    function fa;
        set last "$PWD"
        if test -n "$argv[1]"
            set directory "$argv[1]"
        else
            set directory "$HOME"
        end
        cd (fd --type d --exclude go . "$directory" -H | fzf --scheme=path --bind tab:up,btab:down || printf '%s' "$last")
    end

    # Reboot to Windows
    function windows-reboot
        set windows_entry $(sudo grep -i windows /etc/grub2.cfg | cut -d "'" -f 2)
        sudo grub2-reboot "$windows_entry" && sudo reboot
    end

    # atuin Configurations
    atuin init fish --disable-up-arrow | source

    # View markdown
    function md
        set -l out /tmp/(basename $argv[1]).html
        pandoc $argv >$out
        xdg-open $out
    end

    # Use neovim as the manpage viewer
    function man
        if test -n "$argv[1]"
            set manpage "$argv[1..]"
        else
            echo -e 'What manual page do you want?\nFor example, try \'man man\'.' && return 1
        end
        set manexe (which man)
        $manexe --where (string split ' ' $manpage) && nvim -MR -c "Man $manpage | only"
    end
end

# opam configuration
source /home/lucas/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# pyenv configuration
if type -q pyenv
    pyenv init - | source
end
