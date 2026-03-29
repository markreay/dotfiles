# Minimum supported Bash version
readonly _min_bash_major=4
if (( BASH_VERSINFO[0] < _min_bash_major )); then
    echo
    echo "========================================"
    echo "❌  Ancient Bash detected: $BASH_VERSION"
    echo "    Your dotfiles require >= $_min_bash_major"
    echo "    Current shell: $SHELL"
    if is_macos; then
        HOMEBREW_BASH="/opt/homebrew/bin/bash"
        echo "    macOS ships with Bash 3.2 due to licensing issues."
        # check to see if installed
        if [ ! -x "$HOMEBREW_BASH" ]; then
            echo "    Homebrew Bash not found at $HOMEBREW_BASH"
            echo "    You can install a modern Bash via Homebrew."
            echo "    👉 Run: brew install bash"
        fi
        if ! grep -q "/opt/homebrew/bin/bash" /etc/shells; then
            echo "    Add the new Bash to /etc/shells:"
            echo "    👉 Run: echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells"
        fi
        echo "    Then change your default shell:"
        echo "    👉 Run: chsh -s /opt/homebrew/bin/bash"
    elif is_wsl; then
        echo "    Please upgrade your WSL distribution to get a modern Bash."
        echo "    👉 Run: wsl --update"
    else
        echo "    Please upgrade your Bash installation."
        echo "    👉 On Debian/Ubuntu: sudo apt install bash"
    fi
    echo "========================================"
    echo
fi


set -o noclobber
