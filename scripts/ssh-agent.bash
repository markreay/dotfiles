############################################
# Start ssh-agent
# adapted from https://stackoverflow.com/questions/40549332/how-to-check-if-ssh-agent-is-already-running-in-bash

function check-ssh-agent {
  TITLE Enabling ssh-agent . . .

  SSH_ENV="$HOME/.ssh/environment"
  SSH_ADD_ARGS=""
  SSH_AUTH_SOCK_PATH="$HOME/.ssh/ssh_auth_sock"

  # Prefer stable socket path when available.
  if [[ -S "$SSH_AUTH_SOCK_PATH" ]]; then
    export SSH_AUTH_SOCK="$SSH_AUTH_SOCK_PATH"
  fi

  # Load SSH identities from ssh config
  mapfile -t identity_files < <(awk '/^[[:space:]]*IdentityFile/ {print $2}' ~/.ssh/config | sed 's~^~/~')

  # macOS-specific keychain integration
  if is_mac_os; then
    if grep -q "UseKeychain yes" "$HOME/.ssh/config" 2>/dev/null; then
      SSH_ADD_ARGS=--apple-use-keychain
    else
      WARNING "⚠️ UseKeychain not configured."
      WARNING "    And add this to ~/.ssh/config for each host:"
      echo -e "    UseKeychain yes\n      AddKeysToAgent yes\n      IdentityFile ~/.ssh/id_ed25519"
    fi
  fi

  ssh-add -l &> /dev/null
  if [[ "$?" == 2 ]]; then
    # Try to connect to running ssh-agent
    if [ -f "${SSH_ENV}" ]; then
      . "${SSH_ENV}" > /dev/null
    fi
  fi

  # Drop stale or inaccessible socket paths.
  if [[ -n "${SSH_AUTH_SOCK:-}" && ! -S "$SSH_AUTH_SOCK" ]]; then
    unset SSH_AUTH_SOCK SSH_AGENT_PID
  fi

  if [[ -d "$HOME/.ssh" ]]; then
    local ssh_dir="$HOME/.ssh"
    local ssh_mode
    ssh_mode=$(stat_mode "$ssh_dir" || true)
    if [[ -n "$ssh_mode" && $ssh_mode -gt 700 ]]; then
      WARNING "ssh dir permissions too open: $ssh_dir ($ssh_mode)"
      WARNING "to fix: chmod 700 $ssh_dir"
    fi

    local ssh_file
    for ssh_file in "$ssh_dir"/config \
                    "$ssh_dir"/authorized_keys \
                    "$ssh_dir"/known_hosts \
                    "$ssh_dir"/environment \
                    "$ssh_dir"/id_rsa \
                    "$ssh_dir"/id_ed25519; do
      if [[ -e "$ssh_file" ]]; then
        local ssh_file_mode
        ssh_file_mode=$(stat_mode "$ssh_file" || true)
        if [[ -n "$ssh_file_mode" && $ssh_file_mode -gt 600 ]]; then
          WARNING "ssh file permissions too open: $ssh_file ($ssh_file_mode)"
          WARNING "to fix: chmod 600 $ssh_file"
        fi
      fi
    done
  fi

  ssh-add -l &> /dev/null
  if [[ "$?" == 2 ]]; then
    # Try to restart ssh-agent
    (umask 066; /usr/bin/ssh-agent -a "$SSH_AUTH_SOCK_PATH" | sed 's/^echo/#echo/' > "${SSH_ENV}")
    . "${SSH_ENV}" > /dev/null
    export SSH_AUTH_SOCK="$SSH_AUTH_SOCK_PATH"
    {
      echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK_PATH; export SSH_AUTH_SOCK;"
      echo "SSH_AGENT_PID=$SSH_AGENT_PID; export SSH_AGENT_PID;"
    } > "${SSH_ENV}"
  fi

  ssh-add -l &> /dev/null
  if [[ "$?" == 1 ]]; then
    ssh-add $SSH_ADD_ARGS "${identity_files[@]}" 2>/dev/null
  fi
  ssh-add -l
}

[[ ! $CODESPACES ]] && check-ssh-agent
