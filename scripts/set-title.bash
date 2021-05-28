############################################
# Set window title
#

if [[ $WT_SESSION ]]
then

    TITLE Enabling set window title . . .

    function _update_window_title() {

        WINDOW_TITLE=$(cd "$(echo $PWD)"; basename "$(dirs +0)")
        if $(git rev-parse --is-inside-work-tree 2> /dev/null) && GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
        then
            GIT_REPO=$(git config remote.origin.url | sed 's#.*\/\(.*\)\.git#\1#')
            WINDOW_TITLE=$GIT_REPO\($GIT_BRANCH\)
        fi

        if [[ ! $WSL_DISTRO_NAME ]]
        then 
            if [[ $DISPLAY_HOSTNAME ]]; then
                WINDOW_TITLE="$DISPLAY_HOSTNAME: $WINDOW_TITLE"
            else
                WINDOW_TITLE="$(hostname): $WINDOW_TITLE"
            fi
        fi

        echo -en "\033]0;$WINDOW_TITLE\a"
    }

    if ! [[ $PROMPT_COMMAND =~ "_update_window_title" ]]
    then
        PROMPT_COMMAND="_update_window_title; $PROMPT_COMMAND"
    fi

fi