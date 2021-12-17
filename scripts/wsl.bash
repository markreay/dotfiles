############################################
# Windows Subsystem for Linux Customizations
#

if [ $WSL_DISTRO_NAME ]
then
    TITLE Enabling Windows Subsystem for Linux Customizations . . .

    wsl=$(wslpath $(wslvar SYSTEMROOT)/System32/wsl.exe)
    if [ -e "$wsl" ]
    then
        function reboot() {
            echo Terminating in 5 seconds unless you stop
            sleep 5
            "$wsl" -t $WSL_DISTRO_NAME
        }
        export reboot
    else
        WARNING Cannot find WSL command line tool at $wsl
    fi

    explorer=$(wslpath $(wslvar SYSTEMROOT)/explorer.exe)
    if [ -e "$explorer" ]
    then
        alias explorer=\"$explorer\"
    else
        WARNING Cannot find Windows Explorer at $explorer
    fi
    
    function winpwd() {
        wslpath -w .
    }
    function wincd() {
        cd $(wslpath -u $1)
    }
    
fi

