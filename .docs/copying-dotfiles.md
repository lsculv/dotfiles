# Copying This Dotfiles Repo

As listed in the README, this should be the only set of commands needed to get
up and running with this repo.
```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare https://github.com/lsculv/dotfiles $HOME/.dotfiles
config checkout || \
    config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | \
    xargs -I{} /bin/sh -c 'mkdir -p config-backup/"$(dirname {})"; mv {} config-backup/{}'
config checkout
config config --local status.showUntrackedFiles no
```

## Explanation

The first line:
```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
sets up an alias for easy use of the repo. It functions like the regular `git`
command (so you can add things with `config add`, commit with `config commit`,
etc.) except it will work _globally_. It also knows about the fact that the repo
files that track all of the git objects don't live in the root of the work tree
itself, but rather in the `.dotfiles/` subdirectory (this is what the
`--git-dir=$HOME/.dotfiles/` and `--work-tree=$HOME` flags do).

Next the repo is cloned into the proper `~/.dotfiles/` location:
```bash
git clone --bare https://github.com/lsculv/dotfiles $HOME/.dotfiles
```
Here a `--bare` clone is used because the actual _files_ tracked by the repo
aren't wanted yet, only the git objects.

That's where this slightly complicated command comes in:
```bash
config checkout || \
    config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | \
    xargs -I{} /bin/sh -c 'mkdir -p config-backup/"$(dirname {})"; mv {} config-backup/{}'
```
Only now do we try to `checkout` from the git directory and grab the actual
files. However, this fails if git would overwrite untracked files with ones that
are named the same as in the repo. This will basically always happen because of
`.bashrc` etc. being included for tracking. So, if (when) the first checkout
fails, we try to checkout again knowing it will fail, grabbing the file names
of every conflicting file (`config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | \`).
These trimmed file names are then handed to `xargs` so they can each be placed
into the `config-backup/` directory, just so a file you happened to care about
doesn't get permanently overwritten.

Now its safe to do the final:
```bash
config checkout
```
and, just so your `config status` output is not spammed by all the files in your
home directory you don't need tracking for we do:
```bash
config config --local status.showUntrackedFiles no
```

