# t — tmux session launcher with templates

fzf-driven session manager. Lives at `~/.dotfiles/bin/t`. Run from any
shell (inside or outside tmux).

---

## Menu legend

| Icon  | Meaning                                                              |
| ----- | -------------------------------------------------------------------- |
| ▶ green   | Running session — picking it switches/attaches                   |
| ● yellow  | Templated session not yet running — picking it creates from template |
| ○ gray    | Running ad-hoc session not backed by a template                  |

Below the list, three actions:

- ⏏️ **Detach** (only shown if you're inside tmux)
- ✏️ **Rename Current Session** (only inside tmux)
- ♻️ **Reread Template Cache**
- ➕ **New Session** — prompts for a name, creates and attaches/switches

---

## Templates: the `tmux-session.conf` file

`t` walks `~/src/*/*/` (depth 3) for any file named `tmux-session.conf`.
Each one defines a templated session named after its parent directory.

Two flavors of layout — pick one per file:

### Multiple panes in one window

```bash
SESSION="myproject"
PANES=(
  "edit:nvim"
  "run:npm run dev"
  "logs:tail -f /tmp/log"
)
```

This creates one window with three panes (tiled), each running the
specified command. The first half of each entry (`edit`, `run`, `logs`)
is the pane name; the rest is the command.

### Multiple windows

```bash
SESSION="myproject"
WINDOWS=(
  "edit:nvim:./src"
  "run:npm run dev:./"
  "logs:tail -f /tmp/log:./"
)
```

This creates a session with three windows. Each entry is `name:command:dir`.
The directory is relative to the project root if not absolute.

---

## How discovery and caching work

- Cache lives at `~/.cache/dotfiles/t/templates.txt`
- Rebuilt when the cache file is missing or older than 18 hours
- Force a rebuild via the menu's "♻️ Reread Template Cache" item
- Cache is just a list of directory paths; the templates themselves are
  re-sourced on each launch

If you add a new `tmux-session.conf` and it doesn't appear in the menu
yet, pick "Reread Template Cache" and it'll rerun.

---

## Common workflows

**Start a fresh templated workspace** — first time on a project:

```bash
cd ~/src/org/myproject
echo 'SESSION="myproject"
WINDOWS=("edit:nvim:./" "shell::./")' > tmux-session.conf
t   # picks up the template, lets you launch it
```

**Switch projects** — `t`, type the first few letters, Enter.

**Spin up an ad-hoc session** — `t` → `➕ New Session` → name it.

**Inside tmux, jump to another session** — `t` works from inside too;
it'll `switch-client` instead of `attach`.

**Rename the current session** — `t` → "✏️ Rename Current Session".
Faster than `prefix + $`.

---

## Tips

- **Templates are project-local config** — commit `tmux-session.conf` to
  the repo so any clone of the project gets the same workspace layout.
- **First entry of `PANES`/`WINDOWS` is the starting pane/window** — pick
  the one you'll usually focus on first (e.g. the editor).
- **Empty command in a window** (`shell::./`) just leaves a bash prompt
  open in that directory. Useful for "I'll figure out what to run later."
- **Cache TTL is generous (18h)** — that means new templates won't show
  for up to 18 hours unless you trigger "Reread Template Cache". Worth a
  shortcut alias if you do this often.

---

## See also

- [tmux.md](tmux.md) — the tmux key reference; `t` complements `prefix + s`.
- The script itself at `~/.dotfiles/bin/t` if you want to tweak the menu
  formatting or behavior.
