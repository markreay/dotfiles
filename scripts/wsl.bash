############################################
# Windows Subsystem for Linux Customizations
#

if [ $WSL_DISTRO_NAME ]
then
    TITLE Enabling Windows Subsystem for Linux Customizations . . .

    if dir_in_path /mnt/c/WINDOWS/system32
    then 
        WARNING appendWindowsPath not enabled in /etc/wsl.conf
        INFO
        INFO To correct, add the following lines to /etc/wsl.conf
        INFO
        INFO "   [interop]"
        INFO "   appendWindowsPath=false # append Windows path to \$PATH variable; default is true"
        INFO
        INFO Then restart WSL to refresh by running \"wsl -t $WSL_DISTRO_NAME\" from Windows command prompt.
        INFO
    fi

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

