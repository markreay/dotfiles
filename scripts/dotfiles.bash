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
    docs)
        local docs_dir="$DOTFILES/docs"
        if [[ ! -d "$docs_dir" ]]; then
            echo "No docs directory at $docs_dir"
            return 1
        fi
        # Preview uses field {2} (filename) — field {1} is the display title.
        # Use glow for rendered markdown if installed, else plain cat
        local preview_cmd="cat $docs_dir/{2}"
        if command -v glow >/dev/null 2>&1; then
            preview_cmd="glow -s dark -w \$FZF_PREVIEW_COLUMNS $docs_dir/{2}"
        fi
        # Build "title<TAB>relpath" lines; show only the title in the picker
        # via --with-nth=1, but keep the path in field 2 for preview/open.
        # Falls back to the relative path if the file has no H1
        local selection
        selection=$(
            while IFS= read -r f; do
                local rel="${f#$docs_dir/}"
                local title
                title=$(awk '/^# / { sub(/^# */, ""); print; exit }' "$f")
                [[ -z "$title" ]] && title="$rel"
                printf '%s\t%s\n' "$title" "$rel"
            done < <(find "$docs_dir" -type f -name "*.md" | sort) \
            | fzf --prompt="docs > " --height=80% --reverse --border \
                  --delimiter=$'\t' --with-nth=1 \
                  --preview="$preview_cmd" \
                  --preview-window="right:75%:wrap"
        )
        [[ -z "$selection" ]] && return 0
        local doc="${selection##*$'\t'}"
        if command -v glow >/dev/null 2>&1; then
            glow -p "$docs_dir/$doc"
        else
            ${PAGER:-less} "$docs_dir/$doc"
        fi
        ;;
    *)
        echo command $cmd not recognized
        echo usage: dot edit,git,push,pull,docs
        ;;
    esac
}
