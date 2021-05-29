#! /bin/bash

debug=false

while getopts fd opt
do
    case "$opt" in
        d)
            debug=true
        ;;
        ?)
            echo >&2 "Usage $0 [-fd]"
            exit 2
        ;;
    esac
done

DEBUG() {
    $debug && echo DEBUG: $*
}

script=$(readlink -f $BASH_SOURCE)
dir=$(dirname $script)

DEBUG script = $script
DEBUG dir = $dir

fix_link() {
    
    local src="$1" dest="$2"
    local actual=$(readlink -f $src)
    
    DEBUG src = "$src"
    DEBUG actual = "$actual"
    DEBUG dest = "$dest"
    
    DEBUG -f "$src" = $([[ -f "$src" ]] && echo "true" || echo "false")
    DEBUG -L "$src" = $([[ -L "$src" ]] && echo "true" || echo "false")
 
    if [[ -f "$src" && ! -L "$src" ]]
    then
        echo Normal file exists $src
        echo Installing symlink $src '==>' $dest
        mv -v --backup=numbered $src $src.backup
        ln -sf $dest $src
    elif [[ -z $(readlink $src) ]]
    then
        echo Installing symlink $src '==>' $dest
        ln -s $dest $src
    elif [[ "$actual" != "$dest" ]]
    then
        echo Bad symlink $src '==>' $actual
        echo Installing symlink $src '==>' $dest
        mv -v --backup=numbered $src $src.backup
        ln -sf $dest $src
    fi
}

fix_link ~/.bashrc $dir/bashrc
fix_link ~/.gitconfig $dir/git.config

. ~/.bashrc