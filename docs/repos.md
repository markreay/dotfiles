# repos — bulk operations across all your git repos

Walks every git repo under `$HOME` (or a path you specify) and runs the
same git command in each. Lives at `~/.dotfiles/bin/repos`.

Skipped by default: `~/Music`, `~/Pictures`, `~/Desktop`, `~/Library`.

---

## Commands

| Command                | What it does                                                          |
| ---------------------- | --------------------------------------------------------------------- |
| `repos check`          | Show repos with unpushed commits, stashes, extra branches, or dirty wt |
| `repos status [args]`  | `git status` per repo, only when there's something to show            |
| `repos fetch [args]`   | `git fetch` in each repo                                              |
| `repos git <args...>`  | Run any git command in each repo                                      |
| `repos list`           | List all discovered repos                                             |
| `repos user`           | List repos whose `user.name`/`user.email` differs from global         |
| `repos help`           | Usage                                                                 |

---

## Common usage

**The "what's loose on this machine?" sweep — run this before going on holiday:**

```bash
repos check
```

Output is a per-repo block, only for repos with something interesting:

```
[~/src/org/project]
  branch: main dirty
  ahead: 2 commits
  stashes: 1
  branches: 3 other
```

**Find repos with the wrong git identity** (e.g. you committed as
personal email in a work repo):

```bash
repos user
```

**Bulk fetch everything before going offline:**

```bash
repos fetch --all
```

**Run any git command everywhere** — pull, prune, log:

```bash
repos git pull
repos git remote prune origin
repos git log --oneline -1     # latest commit per repo
```

---

## Scoping to a different base path

```bash
repos --path ~/work check
repos --path /Volumes/external/code list
```

`--path` must come **before** the subcommand.

---

## What `check` shows you, exactly

For each repo, it gathers:

- **branch** — current branch (or `detached`)
- **dirty** — appended to the branch line if `git status -s` has output
- **ahead** — unpushed commits on the current branch vs its upstream
  (or `(no upstream)` if there's no tracking branch)
- **stashes** — count from `git stash list`
- **branches** — count of local branches other than the current

If everything is clean (nothing ahead, no stashes, no extra branches, not
dirty), the repo is silently skipped.

---

## Tips

- **Faster than scripting it yourself** — `repos git <anything>` beats
  writing one-off shell loops.
- **Pair with `hist`** — when you're on a new machine and need to remember
  what you did on the old one, `hist grep` finds the commands and `repos`
  runs them everywhere.
- **CI-style sanity check** — `repos status -s` gives a one-line status
  per repo, useful for a quick "anything I forgot to commit before
  rebooting?" review.
- **The discovery is shallow-ish** — it walks `find ~`, so deeply nested
  repos under skipped directories are missed. Move repos into your home
  if you want them found.
