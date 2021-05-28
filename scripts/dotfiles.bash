TITLE Checking dotfiles . . .

export DOTFILES=$dir

(
    dirName=$(cd $(echo $dir); dirs +0)
    INFO "Using scripts at $dirName"
    
    git-status() {
        git status --porcelain -b --ignore-submodules
    }
    
    cd $dir
    if [ -e .git ]; then
        git fetch --all -q
        if (git-status | head -1 | grep -q '\[behind'); then
            INFO "New shared scripts available!       To update, (cd $dirName; git pull)"
        fi
        if (git-status | head -1 | grep -q '\[ahead'); then
            INFO "Local committed changes to push in $dirName"
        fi
        if [ $(git-status | tail +2 | wc -l) != 0 ]; then
            INFO "Uncommitted changes in $dirName"
            git status -s
        fi
    fi
)