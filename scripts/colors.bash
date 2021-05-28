function WARNING {
    echo -e "\r\033[K\033[38;5;196mWARNING - $*\033[0;00m"
}
function TITLE {
    echo -e -n "\r\033[K\033[38;5;226m$*\033[0;00m\r"
}
function INFO {
    echo -e "\r\033[K\033[38;5;14m$*\033[0;00m"
}
function FIX {
    echo -e "\r\033[K\033[38;5;210m$*\033[0;00m"
}

