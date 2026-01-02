__prompt_user_part() {
    local exit_code=$?
    local green='\[\033[0;32m\]'
    local red='\[\033[1;31m\]'
    local reset='\[\033[0m\]'
    
    if [ -n "${GITHUB_USER}" ]; then
        echo -n "${green}@${GITHUB_USER} "
    else
        echo -n "${green}\u "
    fi
    
    if [ "$exit_code" -ne 0 ]; then
        echo -n "${red}➜"
    else
        echo -n "${reset}➜"
    fi
}

__prompt_git_file_count_cached() {
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
    [ -z "$repo_root" ] && echo "0" && return
    
    local cache_file="/tmp/.git_file_count_$(echo "$repo_root" | md5sum | cut -d' ' -f1)"
    local git_index="$repo_root/.git/index"
    
    # Recalculate if cache missing or .git/index changed
    if [ ! -f "$cache_file" ] || [ "$git_index" -nt "$cache_file" ]; then
        git ls-files "$repo_root" 2>/dev/null | wc -l | tr -d ' ' > "$cache_file"
    fi
    
    cat "$cache_file"
}

__prompt_git_dirty() {
    local yellow='\[\033[1;33m\]'
    local green='\[\033[0;32m\]'
    
    # Check repo size - skip dirty check for large repos (>500 files)
    local file_count=$(__prompt_git_file_count_cached)
    
    if [ -z "$file_count" ] || [ "$file_count" -gt 1000 ]; then
        echo ""
        return
    fi
    
    # Small repo - check for changes
    local git_status=$(git status --porcelain 2>/dev/null)
    
    if [ -n "$git_status" ]; then
        echo " ${yellow}✗"
    else
        echo " ${green}✓"
    fi
}

__prompt_git_branch() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local cyan='\[\033[0;36m\]'
    local red='\[\033[1;31m\]'
    
    if [ -z "$branch" ]; then
        return
    fi
    
    if [ "$branch" = "HEAD" ]; then
        branch=$(git describe --contains --all HEAD 2>/dev/null)
    fi
    
    echo -n "${cyan}(${red}${branch}$(__prompt_git_dirty)${cyan}) "
}

__bash_prompt() {
    local lightblue='\[\033[1;34m\]'
    local removecolor='\[\033[0m\]'
    
    PS1="$(__prompt_user_part) ${lightblue}\w $(__prompt_git_branch)${removecolor}\$ "
}

if [[ "$PROMPT_COMMAND" != *"__bash_prompt"* ]]; then
    PROMPT_COMMAND="__bash_prompt; $PROMPT_COMMAND"
fi

export PROMPT_DIRTRIM=4