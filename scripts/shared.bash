paths() {
    tr ':' '\n' <<<"$PATH"
}

dir_in_path() {
    grep -qFx "$1" <(paths)
}

prepend_to_path() {
    if ! dir_in_path "$1"; then
        PATH="$1:$PATH"
    fi
}
