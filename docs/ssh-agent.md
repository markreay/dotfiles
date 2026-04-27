# ssh-agent — auto-start, key loading, permission checks

Defined in [`scripts/ssh-agent.bash`](../scripts/ssh-agent.bash). Runs
once when each shell starts (skipped in GitHub Codespaces).

The function is exposed as `check-ssh-agent` if you ever need to run it
manually after fixing something.

---

## What happens at shell init

In order:

1. **Detect a forwarded agent** (`SSH_AUTH_SOCK` set but no `SSH_AGENT_PID`).
   If found, just print `Using forwarded SSH agent (N keys)` and exit.
2. **Prefer the stable socket** at `~/.ssh/ssh_auth_sock` if it exists.
   This survives terminal restarts so you don't have to re-add keys.
3. **Read identity files from `~/.ssh/config`** — every `IdentityFile` line.
4. **macOS only:** check that `UseKeychain yes` is configured. If not, warn.
5. **Permission checks** on `~/.ssh` and the usual key files. Warn on
   anything more permissive than `700` for the dir or `600` for files.
6. **Start a new agent** if no existing one is reachable, writing the
   environment to `~/.ssh/environment`.
7. **Add identities** if the agent has none loaded yet.
8. **Print loaded keys** via `ssh-add -l`.

---

## Forwarded agent vs. local agent

| State                                    | What you see at startup                              |
| ---------------------------------------- | ---------------------------------------------------- |
| SSH'd in with `-A`, agent forwarded      | `Using forwarded SSH agent (N keys)`                 |
| Local agent with stable socket alive     | `ssh-add -l` output of loaded keys                   |
| Local agent missing → fresh start        | "Enabling ssh-agent . . ." message + agent created   |
| No identities loaded yet                 | macOS may prompt for passphrase via pinentry         |

A forwarded agent always wins — the script will never start a local one
on top of it.

---

## macOS keychain integration

For passphrase-protected keys, you want this in `~/.ssh/config`:

```
Host *
    UseKeychain yes
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
```

- `UseKeychain yes` — store/retrieve the passphrase from Keychain so
  you only enter it once
- `AddKeysToAgent yes` — auto-load keys into the agent on first use
- `IdentityFile` — the key the script will load via `ssh-add`

When `UseKeychain yes` is set, `check-ssh-agent` runs `ssh-add` with
`--apple-use-keychain` so the keychain is used non-interactively after
the first unlock.

---

## Permission warnings

If any of these come up at shell start, fix them — sshd refuses to use
keys with loose permissions:

```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/known_hosts
chmod 600 ~/.ssh/id_ed25519        # private keys
chmod 644 ~/.ssh/id_ed25519.pub    # public keys are fine readable
```

The script checks the dir and most common files automatically.

---

## Troubleshooting

**"No identities" or `ssh-add -l` shows nothing:**
Run `check-ssh-agent` manually after fixing config, or just open a new
shell.

**Repeated passphrase prompts:**
Confirm `UseKeychain yes` and `AddKeysToAgent yes` are both in
`~/.ssh/config`. Then `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
once to seed the keychain.

**Agent keeps getting reset between terminals:**
The script writes to `~/.ssh/ssh_auth_sock` as a stable path. If that
file isn't sticking around, something else is cleaning it up — check for
launchctl jobs or login shell hooks deleting `~/.ssh/`.

**SSH'd into a remote box and `ssh -A` forwarding isn't working:**
The remote `sshd_config` needs `AllowAgentForwarding yes`. Your local
config also needs `ForwardAgent yes` (per-Host or in a wildcard block).

---

## Tips

- **Forwarded agent is safest for ephemeral remotes** — no keys leave
  your local machine.
- **Don't use a non-passphrase-protected key on macOS** — there's no
  benefit; keychain stores the passphrase anyway, so you only type it
  once and gain real security.
- **`ssh-add -L` (capital L) shows full public keys**, useful to paste
  into GitHub/GitLab settings without `cat`ting the .pub file.
