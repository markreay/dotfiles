# zbundle — bundle git-tracked files to clipboard as markdown

Walks the current git repo, concatenates every text file into a single
markdown document with `### filename` headings, and copies the result to
the clipboard. Lives at `~/.dotfiles/bin/zbundle`.

The intended use is **pasting source into AI prompts** without having to
manually copy-paste each file.

---

## Usage

```bash
zbundle              # bundle all tracked files in the current repo
zbundle --pick       # multi-select via fzf
zbundle --dir <path> # bundle a different repo (must contain .git)
```

Combining works:

```bash
zbundle --dir ~/src/org/some-other-repo --pick
```

---

## What gets included

- Files reported by `git ls-files` (so it **respects `.gitignore`**)
- Only files where `file --mime-type` returns `text/...` — binaries are
  skipped with a `Skipping binary file: <name>` message

Each included file gets:

````markdown
### path/to/file.py

[file contents]

---
````

---

## Clipboard backends (auto-detected)

| Tool      | Where it's used      |
| --------- | -------------------- |
| `pbcopy`  | macOS                |
| `xclip`   | Linux X11            |
| `wl-copy` | Linux Wayland        |

If none are found, zbundle prints the path to a tmp file instead so you
can `cat`/`pbcopy` it manually.

---

## `--pick` mode

Launches fzf with multi-select on the list of git-tracked files.
Preview pane shows the first 500 lines via `bat` (so you'll want
`brew install bat` if you don't have it).

- **Tab** toggles selection
- **Enter** confirms

If you select nothing, zbundle exits silently.

---

## Common workflows

**Send a feature's code to Claude/Copilot for review:**

```bash
zbundle --pick   # tab-select the relevant files
# now paste into the chat
```

**Bundle a small repo wholesale:**

```bash
cd ~/src/small-project
zbundle
```

**Bundle from another repo without leaving the current one:**

```bash
zbundle --dir ~/src/some-other-repo --pick
```

---

## Tips

- **It's all-tracked-files-by-default for a reason.** For small repos
  you usually want everything in context. Use `--pick` only when the
  default would blow past the context window.
- **Auto-skips binaries** so you don't accidentally paste image/PDF
  bytes into a prompt and confuse the model.
- **Output is a temp file at `/tmp/zbundle.XXXXXX.md`** — printed on
  stdout. Useful if you want to review or re-copy without re-running.
- **Pair with `--dry-run`-style flow** — peek at the temp file before
  pasting if you want to sanity-check size/contents.
