#!/bin/bash

# Check if the current system is macOS
is_mac_os() {
    [[ "$(uname)" == "Darwin" ]]
}

# Check if the current system is Windows Subsystem for Linux
is_wsl() {
    [[ -n "$WSL_DISTRO_NAME" ]]
}

# Minimum supported Bash version
readonly _min_bash_major=4
if (( BASH_VERSINFO[0] < _min_bash_major )); then
    echo
    echo "========================================"
    echo "❌  Ancient Bash detected: $BASH_VERSION"
    echo "    Your dotfiles require >= $_min_bash_major"
    echo "    Current shell: $SHELL"
    if is_mac_os; then
        echo "    macOS ships with Bash 3.2 due to licensing issues."
        echo "    You can install a modern Bash via Homebrew."
        echo "    👉 Run: brew install bash && chsh -s /opt/homebrew/bin/bash"
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
