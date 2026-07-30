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

## Setup steps (per machine)

1. Install chezmoi (`sudo port install chezmoi` on macOS w/ MacPorts, or your
   platform's equivalent).
2. Clone or already have `~/dotfiles` checked out.
3. Create `~/.config/chezmoi/chezmoi.toml`:
   ```toml
   sourceDir = "/path/to/dotfiles"  # wherever you cloned it on this machine

   [data]
       name = "Brian D. Weitzner"
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

- **This Mac (bweitzner@Outpace)**: `sshSignProgram` set to 1Password's
  `op-ssh-sign` binary; `blastdbPath` left unset (no space for BLAST
  databases on this machine).
- **Other Mac(s) / Linux machine**: fill in their own `name`/`email`/
  `signingkey`, and `sshSignProgram`/`blastdbPath` only if applicable there.
- `zshrc`'s `$OSTYPE`-based Mac/Linux branching is handled at shell-runtime
  (not chezmoi templating) -- no per-OS chezmoi data needed for that file.

## Once all machines have migrated

Delete `legacy_symlink_setup.sh` and remove the warning notes from
`README.md`.
