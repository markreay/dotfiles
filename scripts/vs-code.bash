############################################
# Visual Studio Code
#

if is_wsl; then
    TITLE Enabling Visual Studio Code . . .

    function enable_vscode() {
        local frag=$1
        local exec=$2
        local warn=${3:-false}

        local user_path="$(wslvar USERPROFILE)/AppData/Local/Programs/$frag/bin/$exec"
        local global_path="$(wslvar ProgramFiles)/$frag/bin/$exec"

        for path in "$user_path" "$global_path"; do
            local vscode_path="$(wslpath -u "$path")"
            if [ -e "$vscode_path" ]; then
                INFO Enabled $exec \(version $("$vscode_path" --version | head -1)\)
                INFO "    at $vscode_path"
                alias "$exec"="\"$vscode_path\""
                return
            fi
        done

        if $warn
        then
            echo $warn
            WARNING "Cannot find $exec at either of the following locations:"
            WARNING ""
            WARNING "    $user_path"
            WARNING "    $global_path"
            WARNING ""
            WARNING "Please install $frag and try again."
        fi
    }

    enable_vscode "Microsoft VS Code" code true
    enable_vscode "Microsoft VS Code Insiders" code-insiders

elif is_linux; then
    # Remote-SSH host. In a plain ssh/tmux session `code` isn't on PATH, and
    # VSCODE_IPC_HOOK_CLI (the socket pointer VS Code injects into its own
    # integrated terminal) is missing — so `code .` has nothing to talk to.
    #
    # Stale ipc sockets pile up from closed windows, and the newest one is
    # frequently dead, so we can't just pick newest-and-go (that spews a raw
    # node ECONNREFUSED trace). Instead probe each socket newest-first with
    # `--status` — a real round-trip to the window's server — and run the
    # command against the first that actually answers. `--version` is useless
    # for this: it prints locally without ever touching the socket.
    #
    # Reuses an already-open Remote-SSH window; it can't cold-launch VS Code
    # on the client. Skipped if a native `code` is on PATH.
    if ! command -v code >/dev/null 2>&1 && [ -d "$HOME/.vscode-server" ]; then
        function code() {
            local shim sock rundir=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
            shim=$(ls -t "$HOME"/.vscode-server/cli/servers/*/server/bin/remote-cli/code 2>/dev/null | head -1)
            [ -n "$shim" ] || { echo "code: no vscode-server shim — open a Remote-SSH window to this host first" >&2; return 1; }
            for sock in $(ls -t "$rundir"/vscode-ipc-*.sock 2>/dev/null); do
                if VSCODE_IPC_HOOK_CLI="$sock" timeout 5 "$shim" --status >/dev/null 2>&1; then
                    VSCODE_IPC_HOOK_CLI="$sock" "$shim" "$@"
                    return
                fi
            done
            echo "code: no live VS Code window connected to this host." >&2
            echo "      Open one from the client (Remote-SSH: Connect to Host), then retry." >&2
            return 1
        }
    fi
fi
