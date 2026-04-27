# hist — bash history supertool

Cross-machine, git-backed bash history with timestamped search. Lives at
`~/.dotfiles/bin/hist`. Storage is `~/.history/<hostname>/<date>.log`,
versioned with git for sync between machines.

---

## Commands

| Command            | What it does                                                       |
| ------------------ | ------------------------------------------------------------------ |
| `hist recent`      | Most recent commands on **this** machine                           |
| `hist recent -a`   | Most recent across **all** machines (use `--all` for the long form)|
| `hist grep <term>` | Search for a term in this machine's history                        |
| `hist grep -a <term>` | Search across all machines                                      |
| `hist sync`        | Commit local changes, pull, push — sync history with the remote    |
| `hist help`        | Usage screen                                                       |

`hist push` is an alias for `hist sync`. With no subcommand, defaults to `recent`.

---

## Search

`hist grep` accepts multiple terms — all must match (AND, not OR):

```bash
hist grep docker compose          # matches lines containing both
hist grep -a kubectl rollout      # search both terms across all machines
```

Output is paged through `less` (with `-FR +G`) so it jumps to the end and
quits if it fits on one screen.

---

## Sync workflow

`hist sync` does three things in order:

1. `git add .` + commit (auto-message tagged with hostname + date)
2. `git pull --rebase` from the remote
3. `git push`

Run it at the end of a session, or on a cron, or just sporadically.
Multiple machines can sync to the same `~/.history` repo; conflicts are
extremely rare because each machine writes to its own `<hostname>/`
subdirectory.

---

## How history gets there

Configured by [`scripts/history.bash`](../scripts/history.bash). Each new
TTY writes to `~/.history/<hostname>/<YYYY-MM-DD>.log` with timestamps
embedded. The file rolls over to a new date automatically when the day
changes. Rolling daily keeps individual files small and makes per-day
greps fast.

`HISTSIZE` is bumped to 100,000, so in-memory recall (the up-arrow you
use in any shell) holds plenty before truncating.

---

## Initial setup on a new machine

1. Clone your `~/.history` repo: `git clone <remote> ~/.history`
2. `hist sync` to pull latest
3. `gawk` must be installed on macOS — `brew install gawk` (already in
   the Brewfile dep check, so the shell init will warn you if it's missing)

If `~/.history` doesn't exist yet, the first new TTY creates it
automatically (per `scripts/history.bash`), but you'll want to `git init`
+ remote it yourself if you want sync.

---

## Tips

- **Daily review** — `hist recent` quickly shows what you did most
  recently on this box.
- **Cross-machine recall** — `hist grep -a 'something specific'` is
  great for "I know I ran this on the laptop but I'm on the desktop."
- **Find a forgotten flag** — `hist grep ssh -L` to find your old port
  forwards.
- **Don't commit secrets** — `~/.history` IS git, so anything pasted
  inline (passwords, tokens) gets committed. Use environment vars or
  `pass` instead. If something slips in: rewrite history (`git filter-repo`)
  before pushing.
