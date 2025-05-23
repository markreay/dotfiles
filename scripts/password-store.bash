TITLE Checking password store . . .

(
    pass-git-status() {
        pass git status --porcelain -b --ignore-submodules
    }

    pass-sync() {
        pass git pull --rebase
        pass git push
    }

    if (pass --help >/dev/null 2>/dev/null); then

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
    fi
)
