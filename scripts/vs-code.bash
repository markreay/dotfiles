############################################
# Visual Studio Code
#

if [ $WSL_DISTRO_NAME ]
then
    TITLE Enabling Visual Studio Code . . .

    vscode=$(wslpath "$(wslvar USERPROFILE)/AppData/Local/Programs/Microsoft VS Code/bin/code")
    if [ ! -e "$vscode" ]
    then
        vscode=$(wslpath "$(wslvar ProgramFiles)/Microsoft VS Code/bin/code")
    fi
    if [ -e "$vscode" ]
    then
        INFO Enabled Visual Studio Code at $vscode
        alias code=\"$vscode\"        
    else
        WARNING Cannot find VS Code at $vscode
    fi
fi

