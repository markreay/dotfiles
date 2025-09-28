if is_mac_os
then

    export BASH_SILENCE_DEPRECATION_WARNING=1

    # lockme alias
    # this will lock the screen and require password on wake
    alias lockme='open -a /System/Library/CoreServices/ScreenSaverEngine.app && sudo -k'

    # Enable Homebrew in the shell
    eval $(/opt/homebrew/bin/brew shellenv)

    (
        # ----------------------------
        # Homebrew Formulae
        # ----------------------------
        declare -A _BREW_FORMULAE=(
        [azure-cli]="Azure tooling, needed if pushing/deploying cloud resources"
        [bash]="Modern shell replacement for macOS’ outdated Bash"
        [fzf]="Fuzzy finder for quick navigation/search in terminal"
        [gawk]="GNU awk, extended scripting capability beyond BSD awk"
        [gh]="GitHub CLI for managing repos/issues/PRs from terminal"
        [pass]="Password manager (with gpg)"
        [pinentry-mac]="GUI pinentry for gpg/pass prompts"
        [pipenv]="Python dependency manager (virtualenv + Pipfile)"
        [pipx]="Run Python apps in isolated environments"
        [poetry]="Python project/packaging tool"
        [pyenv-virtualenv]="Virtualenv support integrated with pyenv"
        [tmux]="Terminal multiplexer for session persistence"
        )

        # ----------------------------
        # Homebrew Casks
        # ----------------------------
        declare -A _BREW_CASKS=(
        [betterdisplay]="Manage display resolutions, scaling, and EDID quirks"
        [docker]="Docker CLI tooling"
        [docker-desktop]="Full Docker Desktop app, GUI + runtime"
        [iterm2]="Preferred terminal emulator"
        [github]="GitHub Desktop app for graphical repo management"
        [rectangle]="Window manager for macOS (tiling, shortcuts)"
        )

        # ----------------------------
        # Check function
        # ----------------------------
        check_brew_deps() {
            local missing=0

            local installed_formulae
            local installed_casks
            installed_formulae=$(brew list --formula)
            installed_casks=$(brew list --cask)

            echo "🔍 Checking Homebrew dependencies..."

            for f in "${!_BREW_FORMULAE[@]}"; do
                if ! grep -qx "$f" <<< "$installed_formulae"; then
                    echo "⚠️  Missing formula: $f — ${_BREW_FORMULAE[$f]}"
                    echo "   Run 👉 brew install $f"
                    missing=1
                fi
            done

            for c in "${!_BREW_CASKS[@]}"; do
                if ! grep -qx "$c" <<< "$installed_casks"; then
                    echo "⚠️  Missing cask: $c — ${_BREW_CASKS[$c]}"
                    echo "   Run 👉 brew install --cask $c"
                    missing=1
                fi
            done

            if [[ $missing -eq 0 ]]; then
                echo "✅ All required brew items are installed."
            fi
        }

        # ----------------------------
        # Auto-run on shell startup
        # ----------------------------
        check_brew_deps
    )

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
