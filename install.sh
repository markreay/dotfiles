#! /bin/bash

fix=false
debug=false

while getopts fd opt
do
    case "$opt" in
        f)
            fix=true
        ;;
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

can_fix=false
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
    
    if [[ -f "$dest" && ! -L "$dest" ]]
    then
        echo Normal file exists $src
        if $fix
        then
            echo Installing symlink $src '==>' $dest
            mv --backup=numbered $src $src.backup
            ln -sf $dest $src
        else
            echo Should be $src '==>' $dest
            can_fix=true
        fi
    elif [[ -z $(readlink $src) ]]
    then
        echo Installing symlink $src '==>' $dest
        ln -s $dest $src
    elif [[ "$actual" != "$dest" ]]
    then
        echo Bad symlink $src '==>' $actual
        if $fix
        then
        echo Installing symlink $src '==>' $dest
            ln -sf $dest $src
        else
            echo      Should be $src '==>' $dest
            can_fix=true
        fi
    fi
}

fix_link ~/.bashrc $dir/bashrc
fix_link ~/.gitconfig $dir/git.config

if $can_fix
then
    echo To fix issues run $0 -f
fi
