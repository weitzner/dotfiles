Dotfiles
========
Managed with [chezmoi](https://www.chezmoi.io/). `dot_foo` -> `~/.foo`;
`*.tmpl` files pull per-machine values from `~/.config/chezmoi/chezmoi.toml`
(untracked) -- see `MACHINES.md`.

⚠️ Don't pull this repo on another machine until ready to immediately run
its chezmoi setup (see `MACHINES.md`). `legacy_symlink_setup.sh` still works
as a fallback but is deprecated.

Install (new machine)
----------------------
``` bash
sudo port install chezmoi   # or platform equivalent
git clone git@github.com:weitzner/dotfiles.git ~/dotfiles
chezmoi --source ~/dotfiles init
# create ~/.config/chezmoi/chezmoi.toml -- see MACHINES.md
chezmoi diff && chezmoi apply
```

Legacy (deprecated)
--------------------
``` bash
git clone git@github.com:weitzner/dotfiles.git ~/dotfiles
cd ~/dotfiles && sh legacy_symlink_setup.sh
```
