TITLE Checking password store . . .

(
    pass-git-status() {
        pass git status --porcelain -b --ignore-submodules
    }

    if (pass --help > /dev/null 2> /dev/null); then
        pass git fetch --all -q
        if (pass-git-status | head -1 | grep -q '\[behind'); then
            INFO "New secrets available!"
            INFO "To update, (pass git pull)"
        fi
        if (pass-git-status | head -1 | grep -q '\[ahead'); then
            INFO "Local committed changes to push in $dirName"
            INFO "To update, (pass git push)"
        fi
    fi
)
