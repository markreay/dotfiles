############################################
# Visual Studio Code
#

if [ $WSL_DISTRO_NAME ]; then
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
fi
