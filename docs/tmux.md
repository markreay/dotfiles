# tmux cheat sheet

Quick reference for the way this dotfiles config drives tmux. Prefix is
`Ctrl+Space` (primary) or `Ctrl+B` (secondary, kept during transition).
Below, `P` = your prefix.

---

## The four to internalize first

| Key                  | What it does                                                     |
| -------------------- | ---------------------------------------------------------------- |
| `t` (from any shell) | fzf session picker — switch, attach, or launch from a template   |
| `P + ,`              | Rename the current window (auto-rename is off)                   |
| `P + z`              | Zoom the active pane to fullscreen; press again to unzoom        |
| `P + q`              | Flash pane numbers — press the number to jump                    |

---

## Panes

| Key                | Action                                                           |
| ------------------ | ---------------------------------------------------------------- |
| `P + "`            | Split horizontal (panes stacked top/bottom). Inherits cwd.       |
| `P + %`            | Split vertical (panes side-by-side). Inherits cwd.               |
| `M-Left` `M-Right` | Move between panes (no prefix)                                   |
| `P + z`            | Zoom toggle                                                      |
| `P + q`            | Show pane numbers                                                |
| `P + space`        | Cycle through preset layouts                                     |
| `P + {` `P + }`    | Swap pane with previous / next                                   |
| `P + Ctrl-arrows`  | Resize active pane                                               |
| `P + x`            | Kill active pane (asks to confirm)                               |
| `P + !`            | Break active pane out into its own new window                    |

Pane indicators in this config:
- **Border** — bright blue around the active pane (primary signal)
- **Background** — active is darker than inactive (secondary, often hidden by program output)

---

## Windows

| Key             | Action                                                              |
| --------------- | ------------------------------------------------------------------- |
| `P + c`         | New window (cwd inherited)                                          |
| `P + ,`         | Rename current window                                               |
| `P + 0..9`      | Jump to window N (numbered from 1 — `base-index 1`)                 |
| `P + n` `P + p` | Next / previous window                                              |
| `P + l`         | Last window (toggles back-and-forth)                                |
| `P + &`         | Kill current window (asks to confirm)                               |
| `P + .`         | Move/renumber current window                                        |

Auto-rename is **off**, so window names are whatever you set. Set them with
`P + ,`. Closed windows auto-renumber to fill gaps (`renumber-windows on`).

---

## Sessions

You have multiple sessions; the launcher of choice is `t`.

| Key                | Action                                                           |
| ------------------ | ---------------------------------------------------------------- |
| `t`                | fzf picker (running + templated + new). **Use this.**            |
| `P + s`            | Built-in interactive session picker (in-tmux fallback)           |
| `P + $`            | Rename session                                                   |
| `P + d`            | Detach (session keeps running)                                   |
| `P + (` `P + )`    | Previous / next session                                          |
| `M-Up` `M-Down`    | Same as `P + (` / `P + )` (no prefix)                            |

From the shell:

```bash
tmux ls                    # list sessions
tmux a                     # attach to most recent
tmux a -t <name>           # attach to specific
tmux new -s <name>         # create named session
tmux kill-session -t <name>  # kill a session
tmux kill-server           # kill ALL sessions (nuclear)
```

---

## Copy mode (scrollback / select / search)

| Key            | Action                                                                |
| -------------- | --------------------------------------------------------------------- |
| `P + [`        | Enter copy mode                                                       |
| Arrow keys     | Move (or PgUp/PgDn)                                                   |
| `/` `?`        | Search forward / backward                                             |
| `q` or `Esc`   | Exit copy mode                                                        |
| `P + ]`        | Paste                                                                 |

Mouse selection works too with `mouse on`. To bypass tmux mouse and use
**native iTerm2 selection** (e.g. for copying URLs), hold `⌥/Option`
while selecting.

---

## Custom bindings (your config)

| Key             | Action                                                            |
| --------------- | ----------------------------------------------------------------- |
| `Shift+Enter`   | Send `Ctrl+J` (newline) — for Claude Code multi-line input        |
| `M-Left/Right`  | Pane navigation                                                   |
| `M-Up/Down`     | Session navigation                                                |
| `P + r`         | Reload `~/.tmux.conf` and show "✅ Reloaded"                      |

---

## Escape hatches

| Key      | Action                                                                  |
| -------- | ----------------------------------------------------------------------- |
| `P + ?`  | Show all current key bindings (the real cheat sheet)                    |
| `P + :`  | Command prompt — type any tmux command (`:source-file ~/.tmux.conf`)    |
| `P + t`  | Big clock                                                               |

---

## The `t` launcher

`t` is your session swiss army knife (`~/.dotfiles/bin/t`). Run it from
any shell — inside or outside tmux:

- **▶ green** — running session, switches/attaches
- **● yellow** — templated session not yet running, creates from template
- **○ gray** — ad-hoc unknown
- Bottom of menu: detach, rename current, reread template cache, new session

Templates are `tmux-session.conf` files anywhere under `~/src/*/*/`. They
define `SESSION`, plus either `PANES` or `WINDOWS` arrays of
`name:command` pairs. Cache rebuilds every 18h (or via menu).

Example `tmux-session.conf`:

```bash
SESSION="myproject"
WINDOWS=(
  "edit:nvim:./src"
  "run:npm run dev:./"
  "logs:tail -f /tmp/log:./"
)
```

---

## Troubleshooting

**Config changes don't appear after `P + r`?**
Some options (window-style, base-index) need a redraw or new pane.
Force redraw: `P + :refresh-client -S`. Last resort: `tmux kill-server`
to restart everything.

**Pane background tint not visible?**
Programs (bash, vim, Claude Code) paint their own background, hiding the
tmux pane bg. Rely on the **border color** as the primary active-pane
signal. Bg tint only shows in margins/empty space.

**iTerm2 colors look weird?**
Check `Profiles → Colors → Minimum contrast` — should be at zero. Otherwise
iTerm2 lifts dim colors and breaks subtle styling.

**TERM doesn't update after changing `default-terminal`?**
TERM is baked in per-session at create time. New `default-terminal` only
applies to sessions started after `tmux kill-server`.
