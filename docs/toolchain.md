# toolchain — opt in/out of optional dev environments

Toggle which optional toolchains are loaded at shell startup. Defined in
[`scripts/toolchain.bash`](../scripts/toolchain.bash). State persists
in `~/.dotfiles/.toolchains`.

---

## Available toolchains

| Toolchain | What it pulls in                                               |
| --------- | -------------------------------------------------------------- |
| Python    | `pipx`, `poetry`, `pyenv-virtualenv` (added to brew dep check) |
| Azure     | `azure-cli` (added to brew dep check)                          |

When a toolchain is **enabled**, its required Homebrew formulae appear
in the `_BREW_FORMULAE` map in `scripts/macos.bash`, so the daily
`brew-deps-check` will warn you if anything is missing.

---

## Usage

```bash
toolchain               # interactive fzf picker (multi-select)
toolchain is-enabled Python   # exit 0 if enabled, 1 if not
toolchain is-enabled Azure    # ditto
```

The picker uses fzf's `--multi` mode:
- **Space** to toggle each toolchain in/out of the selection
- **Enter** to confirm

Whatever's selected gets enabled; whatever's not gets disabled. So make
sure to keep currently-enabled ones selected when you toggle.

Output:

```
🟢 Python toolchain enabled
🔴 Azure toolchain disabled
```

---

## How `is-enabled` is used elsewhere

In [`scripts/macos.bash`](../scripts/macos.bash):

```bash
if toolchain is-enabled Python; then
    _BREW_FORMULAE[pipx]="..."
    _BREW_FORMULAE[poetry]="..."
    _BREW_FORMULAE[pyenv-virtualenv]="..."
fi
```

So enabling Python causes those formulae to be required (and missing
ones flagged at shell start). Same pattern for Azure.

You can use `toolchain is-enabled X` in your own scripts to gate setup
code.

---

## State file

`~/.dotfiles/.toolchains` is a tiny YAML-ish file:

```
Python: true
Azure: false
```

Edit it manually if you prefer (e.g. in a provisioning script). It's
gitignored so per-machine state stays per-machine.

---

## Tips

- **Run on a new machine** — `toolchain` to opt in to whatever you need
  for that box. A laptop may not need Azure, a work box might.
- **Toggling re-runs the brew dep check next shell** — open a new
  terminal after enabling Python and you'll be told what to `brew install`.
- **Adding a new toolchain** — extend the case statement in
  `scripts/toolchain.bash` and the conditional block in `macos.bash`.
