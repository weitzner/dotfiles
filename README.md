Dotfiles
========
Managed with [chezmoi](https://www.chezmoi.io/). `dot_foo` -> `~/.foo`;
`*.tmpl` files pull per-machine values from `~/.config/chezmoi/chezmoi.toml`
(untracked) -- see `MACHINES.md`.

Install (new machine)
----------------------
``` bash
sudo port install chezmoi   # or platform equivalent
git clone git@github.com:weitzner/dotfiles.git ~/dotfiles
chezmoi --source ~/dotfiles init
# create ~/.config/chezmoi/chezmoi.toml -- see MACHINES.md
chezmoi diff && chezmoi apply
```
