TITLE Configuring aliases . . .

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [[ -f ~/local/alias.bash ]]; then
    . ~/local/alias.bash
fi