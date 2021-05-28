TITLE Setting up the extras . . .

############################################
# If launching from Windows,
# change to home directory
[[ $PWD = /mnt/c/Users/* ]] && cd

############################################
# prepend user's home directory bin to PATH
if [ -d ~/bin ]; then
    prepend_to_path ~/bin
fi

############################################
# prepend dotfiles bin to PATH
if [ -d "$dir/bin" ]; then
    prepend_to_path "$dir/bin"
fi

############################################
# prepend yarn bin to PATH
if [ -d ~/.yarn/bin ]; then
    prepend_to_path ~/.yarn/bin
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
