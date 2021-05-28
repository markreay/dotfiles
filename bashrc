script=`readlink -f $BASH_SOURCE`
dir=`dirname $script`

if [ -e ~/.dotfilesrc ]; then
    . ~/.dotfilesrc
fi
. $dir/scripts/shared.bash
. $dir/scripts/colors.bash
. $dir/scripts/alias.bash
. $dir/scripts/dircolors.bash
. $dir/scripts/set-title.bash
. $dir/scripts/git.bash
. $dir/scripts/history.bash
. $dir/scripts/extras.bash
. $dir/scripts/vs-code.bash
. $dir/scripts/wsl.bash
. $dir/scripts/dotfiles.bash
. $dir/scripts/prompt.bash