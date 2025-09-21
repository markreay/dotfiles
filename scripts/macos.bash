if is_mac_os
then

    export BASH_SILENCE_DEPRECATION_WARNING=1

    # lockme alias
    # this will lock the screen and require password on wake
    alias lockme='open -a /System/Library/CoreServices/ScreenSaverEngine.app && sudo -k'

    # Enable Homebrew in the shell
    eval $(/opt/homebrew/bin/brew shellenv)

    (
        # Set global gitignore file
        GITIGNORE_GLOBAL="$HOME/.gitignore_global"

        # Create the file if it doesn't exist
        if [ ! -f "$GITIGNORE_GLOBAL" ]; then
        touch "$GITIGNORE_GLOBAL"
        echo "Created $GITIGNORE_GLOBAL"
        fi

        # Add .DS_Store to the global ignore file if not already present
        if ! grep -qxF '.DS_Store' "$GITIGNORE_GLOBAL"; then
        echo '.DS_Store' >> "$GITIGNORE_GLOBAL"
        echo "Added .DS_Store to $GITIGNORE_GLOBAL"
        fi

        # Configure git to use it globally (if not already set)
        CURRENT_SETTING=$(git config --global core.excludesfile)
        if [ "$CURRENT_SETTING" != "$GITIGNORE_GLOBAL" ]; then
        git config --global core.excludesfile "$GITIGNORE_GLOBAL"
        echo "Configured Git to use $GITIGNORE_GLOBAL for global ignores"
        fi
    )
fi
