# My Public Dotfiles
These are my public dotfiles, convienitly in their own git repo for easy copying
to new machines. Any relevant docs can be found in the `.github/docs/`
directory, along with a copy of the BSD 3-Clause licese at `.github/LICENSE`.

## Setup

Use the following commands to install the dotfiles onto a new machine. This will
create a backup of the files that needed to be overwritten when checking out
from the `dotfiles` repo. This will almost always happen due to `.bashrc` being
included, among others.
```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare https://github.com/lsculv/dotfiles $HOME/.dotfiles
config checkout || \
    config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | \
    xargs -I{} /bin/sh -c 'mkdir -p config-backup/"$(dirname {})"; mv {} config-backup/{}'
config checkout
config config --local status.showUntrackedFiles no
```

After this setup it is probably a good idea to reboot, or at least restart any
programs that are effected by these config changes.

