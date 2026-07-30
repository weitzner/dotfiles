Per-machine chezmoi setup
=========================

`name`/`email`/`signingkey` have no default (set explicitly per machine).
`sshSignProgram`/`blastdbPath` default to `""` via `.chezmoidata.yaml`.

## micromamba (needed by dot_zshrc, assumes conda/miniforge already installed)

```bash
ARCH=osx-arm64  # or osx-64 (Intel Mac) / linux-64 (Linux)
curl -Ls "https://micro.mamba.pm/api/micromamba/${ARCH}/latest" | tar -xvj bin/micromamba
mkdir -p "$HOME/miniforge3/bin"
mv bin/micromamba "$HOME/miniforge3/bin/micromamba"
```

## Setup

1. `sudo port install chezmoi` (or platform equivalent).
2. `~/.config/chezmoi/chezmoi.toml`:
   ```toml
   sourceDir = "/path/to/dotfiles"

   [data]
       name = "Your Name"
       email = "..."
       signingkey = "..."          # SSH public key, or omit for none
       # sshSignProgram = "..."    # e.g. 1Password's op-ssh-sign, if using SSH signing
       # blastdbPath = "..."       # only if this machine has BLAST database space
   ```
3. `chezmoi diff && chezmoi apply`.
4. Verify: `git config --get user.signingkey` matches what you set above.

Once every machine has migrated: delete `legacy_symlink_setup.sh` and the
warning in `README.md`.
