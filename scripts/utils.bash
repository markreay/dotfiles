#!/bin/bash

# Check if the current system is macOS
is_mac_os() {
    [[ "$(uname)" == "Darwin" ]]
}

# Check if the current system is Windows Subsystem for Linux
is_wsl() {
    [[ -n "$WSL_DISTRO_NAME" ]]
}
