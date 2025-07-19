TITLE Setting up git . . .

############################################
# Set default editor to VIM
export EDITOR=vim

(
    if [[ ! $CODESPACES ]]
    # Codespaces doesn't support global configuration - configuration is per repo
    then

        DEFAULT_GIT_BRANCH=main

        if [[ ! $(git config --global --get init.defaultBranch)  ]]
        then
            WARNING No default branch in git config
            FIX git config --global init.defaultBranch $DEFAULT_GIT_BRANCH
        elif [[ ${GIT_DEFAULT_BRANCH:-$DEFAULT_GIT_BRANCH} != $(git config --global --get init.defaultBranch) ]]
        then
            WARNING Default branch in git config is not $DEFAULT_GIT_BRANCH
            FIX git config --global init.defaultBranch $DEFAULT_GIT_BRANCH
        fi

        if [[ ! $(git config --global --get user.name) ]]
        then
            WARNING No name in git config
            FIX git config --global user.name YOUR NAME
        fi

        if [[ ! $(git config --global --get user.email) ]]
        then
            WARNING No name in git config
            FIX git config --global user.email YOUR@EMAIL.ADDRESS
        fi

    fi
)