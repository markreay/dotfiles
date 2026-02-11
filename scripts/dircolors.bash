TITLE Applying dircolors . . .

if which dircolors > /dev/null
then
    eval "$(dircolors "$dir/.dir_colors")"
fi