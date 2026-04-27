# dot — manage the dotfiles repo itself

`dot` is a shell function that scopes git operations to `$DOTFILES` and
provides a small set of conveniences. Defined in
[`scripts/dotfiles.bash`](../scripts/dotfiles.bash).

---

## Subcommands

| Command         | What it does                                                        |
| --------------- | ------------------------------------------------------------------- |
| `dot edit`      | Opens the dotfiles repo in VS Code (`code $DOTFILES`)               |
| `dot docs`      | fzf picker over `~/.dotfiles/docs/*.md`, renders with glow          |
| `dot git <args>`| Run any git command inside `$DOTFILES`                              |
| `dot pull`      | `git pull` in `$DOTFILES`                                           |
| `dot push`      | `git push` from `$DOTFILES`                                         |

No-arg or unknown subcommand prints the usage list.

---

## `dot docs`

Cheat-sheet picker. Each `.md` in `~/.dotfiles/docs/` becomes an entry.

- Picker shows the doc's first H1 as the label (falls back to the filename)
- Live rendered preview on the right via `glow` (or plain `cat` if not installed)
- Enter opens the doc in `glow -p` (paged TUI) or `${PAGER:-less}`

To enable rendered preview/view, install glow:

```bash
brew install glow
```

(It's listed in the Brewfile dep check, so the shell init will warn you.)

---

## Background checks

When a shell starts (and once per 18h via `dotfiles_run_every`), the
init code:

1. Fetches the `$DOTFILES` remote and warns if updates are available
   (`📦 Dotfiles: Updates available. Run 'dot pull' to update.`)
2. Warns about local commits ahead of remote (`dot push`)
3. Warns about uncommitted changes (`dot git commit`)

These nudges aim to keep the dotfiles repo in sync without you needing
to think about it.

---

## Adding a new doc

1. Write `~/.dotfiles/docs/<name>.md`. Start with `# Title` so the picker
   has a label.
2. `dot docs` → it'll show up.
3. Commit and push: `dot git add docs/ && dot git commit -m "..."` then
   `dot push`.

---

## Tips

- **Quick edit cycle** — `dot edit` opens the whole repo in VS Code; faster
  than `cd $DOTFILES && code .`.
- **One-off git ops** — `dot git diff`, `dot git log --oneline`, etc., all
  scoped to the dotfiles repo without changing your CWD.
- **Cross-machine sync** — pair with `hist sync`. They're both git-backed
  and meant to be run periodically to keep multiple machines in sync.
