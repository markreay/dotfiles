TITLE Configuring aliases . . .

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

function axe() {
    (
        cd ~/Downloads || return
        cmd.exe /c axe $*
    )
}

if [[ -f ~/local/alias.bash ]]; then
    . ~/local/alias.bash
fi