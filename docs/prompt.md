# prompt — what every part of the bash prompt means

Defined in [`scripts/prompt.bash`](../scripts/prompt.bash). Rebuilt on
every command via `PROMPT_COMMAND`.

---

## Anatomy

```
hostname ➜ ~/src/org/project (feature-branch ✓) $
└── 1   └─2 └────────── 3 ───  └────── 4 ──────── 5
```

| #   | Element            | Color           | Meaning                                                  |
| --- | ------------------ | --------------- | -------------------------------------------------------- |
| 1   | Hostname (short)   | Green           | Stripped to the first `.` segment                        |
| 1b  | `(username)`       | Gray            | Only shown if `$USER` doesn't match the owner-username pattern in `scripts/prompt.bash` (i.e. you're logged into someone else's box) |
| 2   | `➜`                | Reset / **Red** | **Red = the previous command failed** (non-zero exit). Otherwise default fg. |
| 3   | Working dir        | Light blue      | Truncated via `PROMPT_DIRTRIM=4` (keeps last 4 segments) |
| 4   | Git branch         | Cyan + red      | `(branch_name)` only inside a git repo                   |
| 5   | Git dirty marker   | ✓ green / ✗ yellow | ✓ = clean, ✗ = uncommitted changes. **Skipped on repos > 1000 files** for speed. |

---

## Exit-status indicator (the `➜`)

The arrow turns **red** when the previous command exited non-zero. This
is the fastest way to notice failures you might otherwise miss — `make`
that returned 1, a test runner that printed "all good!" then exited 1
because of a coverage threshold, etc.

If your prompt is showing red `➜` and you don't know why:

```bash
echo $?    # actually no — too late, the prompt itself reset $?
           # solution: glance at the previous command's output, or run it again
```

(The arrow is the cleanest exit-code surface bash gives you for free.)

---

## Git dirty check — when ✓/✗ appears

For each prompt redraw, the prompt asks: is the working tree dirty?

That's `git status --porcelain` under the hood. On large repos this gets
slow, so the prompt **caches the file count** per repo (in `/tmp/.git_file_count_<hash>`,
invalidated when `.git/index` changes) and **skips the dirty check
entirely on repos with more than 1000 files**. So inside a giant
monorepo, you'll see the branch but no ✓/✗ — that's intentional, not a
bug. Run `git status` directly when you need it.

---

## Tweaking it

The whole thing is small (~85 lines). To change colors, edit
[`scripts/prompt.bash`](../scripts/prompt.bash). The color codes are
inline ANSI escapes — search for the named locals like `green`, `cyan`,
`yellow`.

**To change the dirty-check threshold** — line 48: `if [ "$file_count" -gt 1000 ]`.

**To always show username** — remove the conditional in `__prompt_user_part`.

**To suppress dirty checks entirely** — replace `__prompt_git_dirty` with
`echo ""`.

**To shorten/lengthen the path** — `export PROMPT_DIRTRIM=N` (line 90).

---

## Tips

- **Red `➜` is the most useful signal here.** Train your eye on it.
- **The cyan `(branch ✓)` block tells you a lot at a glance**: are you
  on the right branch, do you have uncommitted work, are you in a repo
  at all.
- **Detached HEADs show `(<commit-or-tag>)`** because of the
  `git describe --contains --all HEAD` fallback — useful when bisecting.
