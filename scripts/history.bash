############################################
# History
#
TITLE Enabling command history . . .

# History file is now .history/20YY-MM-DD_tty1
# Inspired by https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
HOSTNAME=$(hostname)
HOSTNAME_SHORT=$(hostname | cut -d '.' -f 1 | tr '[:upper:]' '[:lower:]')
HISTPATH=$HOME/.history/$HOSTNAME_SHORT
mkdir -p $HISTPATH
chmod 700 $HISTPATH
HISTFILE="$HISTPATH/$(date +%Y-%m-%d)_$(tty | sed 's/\///g;s/^dev//g')"

# Include timestamps in history
HISTTIMEFORMAT="%H:%M:%S "

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# Write history after each command
_bash_history_append() {
    builtin history -a
}

if [[ "$PROMPT_COMMAND" != *"_bash_history_append"* ]]; then
    PROMPT_COMMAND="_bash_history_append; $PROMPT_COMMAND"
fi

# compute time since last commit of history and if > 24 hours, recommend running "hist push" and give the number of days since last commit
_last_hist_commit() {
    if git -C "$HISTPATH" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        last_commit_epoch=$(git -C "$HISTPATH" log -1 --format=%ct 2>/dev/null || echo 0)
        now_epoch=$(date +%s)
        if [ $last_commit_epoch -ne 0 ]; then
            diff_days=$(( (now_epoch - last_commit_epoch) / 86400 ))
            if [ $diff_days -gt 0 ]; then
                echo "It's been $diff_days day(s) since your last history commit. Consider running 'hist push' to back up your history."
            fi
        else
            echo "No commits found in history. Consider running 'hist push' to back up your history."
        fi
    else
        echo "No git repository found in $HISTPATH. Consider initializing one and running 'hist push' to back up your history."
    fi
}
_last_hist_commit

