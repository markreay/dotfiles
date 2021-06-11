TITLE Setting up git . . .

############################################
# Set default editor to VIM
export EDITOR=vim

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