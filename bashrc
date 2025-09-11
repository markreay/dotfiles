# suppress dotfiles if we're in an SSH session AND it's not interactive
if [ -n "$SSH_CONNECTION" ] && [[ ! $- =~ i ]]; then
    DOTFILES_SUPPRESS_SCRIPTS=True
fi


if [[ ! $DOTFILES ]] && [[ ! $DOTFILES_SUPPRESS_SCRIPTS ]]
then
    if which realpath > /dev/null 
    then
        resolvelink() { 
            realpath $* 
        }
    else
        resolvelink() { 
            readlink -f $* 
        }
    fi

    script=$(resolvelink $BASH_SOURCE)
    dir=`dirname $script`

    if [ -e ~/.dotfilesrc ]; then
        . ~/.dotfilesrc
    fi
    . $dir/scripts/utils.bash
    . $dir/scripts/macos.bash
    . $dir/scripts/shared.bash
    . $dir/scripts/colors.bash
    . $dir/scripts/alias.bash
    . $dir/scripts/dircolors.bash
    . $dir/scripts/set-title.bash
    . $dir/scripts/ssh-agent.bash
    . $dir/scripts/git.bash
    . $dir/scripts/gnupg.bash
    . $dir/scripts/history.bash
    . $dir/scripts/extras.bash
    . $dir/scripts/vs-code.bash
    . $dir/scripts/wsl.bash
    . $dir/scripts/node.bash
    . $dir/scripts/dotfiles.bash
    . $dir/scripts/password-store.bash
    . $dir/scripts/prompt.bash
    . $dir/scripts/python.bash
    INFO "                                                                      "
fi
