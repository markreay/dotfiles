#!/usr/bin/env bash

# Reusable function to determine if an operation should run based on cache age
# Usage: dotfiles_run_every <duration> <operation-name>
# Duration examples: 30m, 2h, 1d, 18h
# Returns: 0 (true) if should run, 1 (false) if cached

if [[ -z "${DOTFILES_STAT_HELPERS_LOADED:-}" ]]; then
    _stat_helper_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=/dev/null
    . "${_stat_helper_dir}/stat.bash"
    unset _stat_helper_dir
fi

dotfiles_run_every() {
    local duration="$1"
    local operation_name="$2"
    local cache_dir="$HOME/.cache/dotfiles"
    local cache_file="$cache_dir/${operation_name}"
    
    # Parse duration into seconds
    local duration_seconds=0
    if [[ "$duration" =~ ^([0-9]+)m$ ]]; then
        duration_seconds=$((${BASH_REMATCH[1]} * 60))
    elif [[ "$duration" =~ ^([0-9]+)h$ ]]; then
        duration_seconds=$((${BASH_REMATCH[1]} * 3600))
    elif [[ "$duration" =~ ^([0-9]+)d$ ]]; then
        duration_seconds=$((${BASH_REMATCH[1]} * 86400))
    else
        echo "Invalid duration format. Use: 30m, 2h, 1d" >&2
        return 1
    fi
    
    # Create cache directory if needed
    mkdir -p "$cache_dir"
    
    # Check if cache exists and is still valid
    if [[ -f "$cache_file" ]]; then
        local last_run=""
        if last_run=$(stat_mtime "$cache_file"); then
            local now=$(date +%s)
            local age=$((now - last_run))
            if (( age < duration_seconds )); then
                return 1  # Don't run (cached)
            fi
        fi
    fi
    
    # Cache is stale or doesn't exist - mark for running
    touch "$cache_file"
    return 0  # Should run
}

# Helper to clear a specific cache
dotfiles_clear_cache() {
    local operation_name="$1"
    local cache_file="$HOME/.cache/dotfiles/${operation_name}"
    rm -f "$cache_file"
}

# Helper to clear all caches
dotfiles_clear_all_caches() {
    rm -rf "$HOME/.cache/dotfiles"
}
