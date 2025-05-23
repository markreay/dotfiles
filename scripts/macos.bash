if [[ $OSTYPE == "darwin"* ]]
then

    export BASH_SILENCE_DEPRECATION_WARNING=1

    # Enable Homebrew in the shell
    eval $(/opt/homebrew/bin/brew shellenv)

fi
