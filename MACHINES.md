Per-machine chezmoi setup
=========================

This repo's tracked `.chezmoidata.yaml` provides defaults for optional
values. Per-machine identity (`name`/`email`/`signingkey`) has **no**
default -- it must be set explicitly on every machine, so identity is never
silently wrong. Each machine's `~/.config/chezmoi/chezmoi.toml` is local and
untracked (never committed).

⚠️ **Do not `git pull` this repo on another machine until you're ready to
immediately run that machine's `chezmoi init`/`chezmoi apply` steps below.**
The old `legacy_symlink_setup.sh` is kept functional as a fallback, but is
deprecated -- don't rely on it once you've started this migration.

## Prerequisite: micromamba

`dot_zshrc` activates conda's `base` environment on every shell start via
**micromamba** (not conda's own shell hook -- conda's is a slow Python-based
CLI; micromamba is a small standalone binary that does the same activation
near-instantly). This assumes conda/miniforge is already installed on the
machine; it does not install conda itself. If `$HOME/miniforge3/bin/micromamba`
doesn't exist yet, every new shell will fail at that line. Install it once,
into the existing miniforge install -- set `ARCH` to match this machine
(`osx-arm64` for Apple Silicon, `osx-64` for Intel Mac, `linux-64` for
Linux), then run:

```bash
ARCH=osx-arm64  # change to osx-64 (Intel Mac) or linux-64 (Linux) as needed
curl -Ls "https://micro.mamba.pm/api/micromamba/${ARCH}/latest" | tar -xvj bin/micromamba
mkdir -p "$HOME/miniforge3/bin"
mv bin/micromamba "$HOME/miniforge3/bin/micromamba"
```

Verify: `$HOME/miniforge3/bin/micromamba --version` should print a version,
and `$HOME/miniforge3/bin/micromamba env list` should show the same
environments `conda env list` shows (confirms it's reading the existing
miniforge install correctly, not a separate empty root).

## Setup steps (per machine)

1. Install chezmoi (`sudo port install chezmoi` on macOS w/ MacPorts, or your
   platform's equivalent).
2. Clone or already have `~/dotfiles` checked out.
3. Create `~/.config/chezmoi/chezmoi.toml`:
   ```toml
   sourceDir = "/path/to/dotfiles"  # wherever you cloned it on this machine

   [data]
       name = "Your Name"
       email = "..."          # this machine's git identity
       signingkey = "..."     # this machine's signing key (or omit for none)
       # Optional, both default to "" via .chezmoidata.yaml if omitted:
       # sshSignProgram = "/path/to/an/ssh-sign/program"  # only if using SSH-format signing
       # blastdbPath = "/path/to/blast/databases"          # only if this machine has space for them
   ```
4. `chezmoi diff` -- review before applying.
5. `chezmoi apply`.
6. Verify (same checks used during the original migration):
   ```
   expected_key="<this machine's own signing key, or leave unset if none>"
   actual_key="$(git config --get user.signingkey)"
   [[ "$actual_key" == "$expected_key" ]] && echo PASS || echo FAIL
   ```

## Known per-machine differences today

- **This Mac**: `sshSignProgram` set to 1Password's
  `op-ssh-sign` binary; `blastdbPath` left unset (no space for BLAST
  databases on this machine).
  - `signingkey` here is the SSH **public** key (an `ssh-rsa AAAA...`
    string) -- safe to store in plaintext, same as an `authorized_keys`
    entry. It only identifies *which* key to sign with; it is not a secret.
    The private key never appears in this file or in git history -- it
    lives only in 1Password's encrypted vault. `sshSignProgram` is what
    makes that work: git shells out to `op-ssh-sign` whenever it needs an
    actual signature, and 1Password performs the cryptographic signing
    operation internally, so the private key material never touches disk
    in plaintext. The two fields aren't redundant -- `signingkey` says
    *which* key, `sshSignProgram` says *how* to sign without exposing it.
- **Other Mac(s) / Linux machine**: fill in their own `name`/`email`/
  `signingkey`, and `sshSignProgram`/`blastdbPath` only if applicable there.
- `zshrc`'s `$OSTYPE`-based Mac/Linux branching is handled at shell-runtime
  (not chezmoi templating) -- no per-OS chezmoi data needed for that file.

## Once all machines have migrated

Delete `legacy_symlink_setup.sh` and remove the warning notes from
`README.md`.
