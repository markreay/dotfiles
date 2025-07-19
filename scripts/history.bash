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
