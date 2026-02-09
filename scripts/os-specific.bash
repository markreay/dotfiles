# Check if the current system is macOS
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

# Check if the current system is Windows Subsystem for Linux
is_wsl() {
    [[ -n "$WSL_DISTRO_NAME" ]] || grep -qi WSL /proc/version 2>/dev/null
}

if is_macos
then
    . $dir/scripts/macos.bash
fi

if is_wsl
then
    . $dir/scripts/wsl.bash
fi

if ! is_macos && ! is_wsl
then
    WARNING "Unsupported OS detected. Some features may not work as expected."
    WARNING "Current system: $(uname -a)"
    WARNING "Supported systems are macOS and Windows Subsystem for Linux (WSL)."
fi