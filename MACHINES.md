Per-machine chezmoi setup
=========================

`name`/`email`/`signingkey` have no default (set explicitly per machine).
`sshSignProgram`/`blastdbPath` default to `""` via `.chezmoidata.yaml`.

## micromamba (needed by dot_zshrc/dot_direnvrc, assumes conda already installed)

`dot_zshrc`/`dot_direnvrc` auto-detect the conda root (`~/miniforge3`,
`~/mambaforge`, or `~/miniconda3` -- whichever exists), so this just needs
micromamba installed into whichever one is actually present on this machine.

Check arch on Linux first: `uname -m` -> `x86_64` = `linux-64`, `aarch64` =
`linux-aarch64` (e.g. 64-bit Raspberry Pi OS). `armv7l` (32-bit) has no
prebuilt micromamba binary.

```bash
ARCH=osx-arm64  # or osx-64 (Intel Mac) / linux-64 / linux-aarch64 (Linux)
CONDA_ROOT=~/miniforge3  # or ~/mambaforge / ~/miniconda3 -- whichever this machine has
curl -Ls "https://micro.mamba.pm/api/micromamba/${ARCH}/latest" | tar -xvj bin/micromamba
mkdir -p "${CONDA_ROOT}/bin"
mv bin/micromamba "${CONDA_ROOT}/bin/micromamba"
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
