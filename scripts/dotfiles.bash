TITLE Checking dotfiles . . .

export DOTFILES=$dir

DOTFILES_LOADED=True

(
    dirName=$(
        cd $(echo $dir)
        dirs +0
    )
    INFO "Using scripts at $dirName"

    git-status() {
        git status --porcelain -b --ignore-submodules
    }

    if dotfiles_run_every 18h dotfiles-update-check; then
        (
            cd $dir
            if [ -e .git ]; then
                git fetch --all -q
                local=$(git rev-parse @)
                remote=$(git rev-parse @{u})
                base=$(git merge-base @ @{u})
                
                if [ $local != $remote ] && [ $local = $base ]; then
                    echo "📦 Dotfiles: Updates available. Run 'dot pull' to update."
                fi
            fi
        )
    fi

    cd $dir
    if [ -e .git ]; then
        git fetch --all -q
        if (git-status | head -1 | grep -q '\[behind'); then
            INFO "New shared scripts available!"
            INFO "To update, (dot pull)"
        fi
        if (git-status | head -1 | grep -q '\[ahead'); then
            INFO "Local committed changes to push in $dirName"
            INFO "To update, (dot push)"
        fi
        if [ $(git-status | tail -n +2 | wc -l) != 0 ]; then
            INFO "Uncommitted changes in $dirName"
            git status -s
            INFO "To update, (dot git commit)"
        fi
    fi
)

function dot() {
    cmd=$1
    shift
    case $cmd in
    git)
        (
            cd $DOTFILES
            git $*
        )
        ;;
    pull)
        (
            cd $DOTFILES
            git pull $*
        )
        ;;
    push)
        (
            cd $DOTFILES
            git push $*
        )
        ;;
    edit)
        code $DOTFILES
        ;;
    *)
        echo command $cmd not recognized
        echo usage: dot edit,git,push,pull
        ;;
    esac
}
