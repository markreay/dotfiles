# Check if the current system is macOS
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

# Check if the current system is Windows Subsystem for Linux
is_wsl() {
    [[ -n "$WSL_DISTRO_NAME" ]] || grep -qi WSL /proc/version 2>/dev/null
}

# Check for Linux
is_linux() {
    [[ "$(uname)" == "Linux" ]] && ! is_wsl
}

if is_macos
then
    . $dir/scripts/macos.bash
fi

if is_wsl
then
    . $dir/scripts/wsl.bash
fi

if is_linux && ! is_wsl
then
    . $dir/scripts/linux.bash
fi

if ! is_macos && ! is_wsl && ! is_linux
then
    WARNING "Unsupported OS detected. Some features may not work as expected."
    WARNING "Current system: $(uname -a)"
    WARNING "Supported systems are macOS, Windows Subsystem for Linux (WSL), and Linux."
fi