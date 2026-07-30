Dotfiles
========
Configuration files the way we like 'em!

This repo is managed with [chezmoi](https://www.chezmoi.io/). Files here use
chezmoi's naming convention (`dot_foo` -> `~/.foo`); templated files
(`*.tmpl`) render per-machine values (git identity, BLAST database path,
etc.) from each machine's local, untracked `~/.config/chezmoi/chezmoi.toml`
-- see `MACHINES.md` for what each machine needs to set.

I (@weitzner) prefer `zsh` as my shell, with `oh-my-zsh`. `dot_zshrc` and the
custom `dot_oh-my-zsh/custom/verbose.zsh-theme` theme file handle that setup.

**⚠️ Before pulling this repo on another machine**: make sure you're ready to
immediately run that machine's chezmoi migration (see `MACHINES.md`). This
repo used to be deployed via `legacy_symlink_setup.sh`; that script is
deprecated but kept functional until every machine has migrated to chezmoi.
Pulling the current state of this repo on a machine still relying on the old
script, without immediately following up with `chezmoi apply`, will leave
that machine without a working deployment mechanism.

Installation (new machine)
---------------------------
``` bash
sudo port install chezmoi   # or your platform's equivalent
git clone git@github.com:weitzner/dotfiles.git ~/dotfiles
chezmoi --source ~/dotfiles init
# create ~/.config/chezmoi/chezmoi.toml with this machine's [data] values
# -- see MACHINES.md
chezmoi diff    # review before applying
chezmoi apply
```

To persist `~/dotfiles` as the default source directory (so plain
`chezmoi apply`/`chezmoi diff` work without `--source` every time), set
`sourceDir` in `~/.config/chezmoi/chezmoi.toml` (see `MACHINES.md` for a full
example).

Legacy installation (deprecated, do not use on new machines)
--------------------------------------------------------------
``` bash
git clone git@github.com:weitzner/dotfiles.git ~/dotfiles
cd ~/dotfiles
sh legacy_symlink_setup.sh
```
