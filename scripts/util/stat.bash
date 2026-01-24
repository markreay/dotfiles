#!/usr/bin/env bash

DOTFILES_STAT_HELPERS_LOADED=1

stat_mtime() {
    local path="$1"
    local out=""
    if out=$(stat -c %Y "$path" 2>/dev/null); then
        :
    elif out=$(stat -f %m "$path" 2>/dev/null); then
        :
    else
        return 1
    fi
    [[ "$out" =~ ^[0-9]+$ ]] || return 1
    printf '%s\n' "$out"
}

stat_size() {
    local path="$1"
    local out=""
    if out=$(stat -c %s "$path" 2>/dev/null); then
        :
    elif out=$(stat -f %z "$path" 2>/dev/null); then
        :
    else
        return 1
    fi
    [[ "$out" =~ ^[0-9]+$ ]] || return 1
    printf '%s\n' "$out"
}
