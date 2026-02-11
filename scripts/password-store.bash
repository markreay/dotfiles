TITLE Checking password store . . .

(
    pass-git-status() {
        pass git status --porcelain -b --ignore-submodules
    }

    pass-sync() {
        if ! pass --help >/dev/null 2>&1; then
            echo "pass is not installed"
            return 1
        fi
        pass git pull --rebase
        pass git push
    }

    if dotfiles_run_every 18h password-store-fetch; then
        if (pass --help >/dev/null 2>/dev/null); then
            (
                pass git fetch --all -q
                
                has_remote=$(pass git rev-parse --abbrev-ref @{u} 2>/dev/null)
                if [ -z "$has_remote" ]; then
                    echo "🔐 Password Store: No remote repository found."
                    return
                fi
                local=$(pass git rev-parse @)
                remote=$(pass git rev-parse @{u})
                base=$(pass git merge-base @ @{u})
                
                if [ $local != $remote ] && [ $local = $base ]; then
                    echo "🔐 Password Store: Updates available."
                fi

                absPath=$(pass git rev-parse --show-toplevel)
                nicePath=${absPath/#$HOME/~}

                pass git fetch --all -q

                if (pass-git-status | head -1 | grep -q '\[ahead\s[0-9]*,\sbehind\s[0-9]*\]'); then
                    INFO "Local committed changes to push and new secrets available in $nicePath"
                    INFO "To update, (pass-sync)"
                elif (pass-git-status | head -1 | grep -q '\[behind'); then
                    INFO "New secrets available!"
                    INFO "To update, (pass git pull)"
                elif (pass-git-status | head -1 | grep -q '\[ahead'); then
                    INFO "Local committed changes to push in $nicePath"
                    INFO "To update, (pass git push)"
                fi
            )
        fi
    fi
)
