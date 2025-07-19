BEGIN {
    tty_color = "\033[38;5;36m"     # Cyan-ish
    date_color = "\033[1;38;5;244m" # Faint grey
    cmd_color = "\033[0m"           # Reset/default
    reset = "\033[0m"
}
FILENAME ~ /[^/]+$/ {
    tty = FILENAME;
    sub(/.*\//, "", tty);            # strip path
    sub(/^[0-9\-]+_/, "", tty);      # strip date_
}
/^#/ {
    split(substr($0, 2), meta, ":");
    ts = meta[1];
    dir = meta[2];
    getline cmd;
    if (SEARCH == "" || cmd ~ SEARCH) {
        printf "%s%s%s  %s%-8s%s  %s%s%s\n",
            date_color, strftime(DATE_FMT, ts), reset,
            tty_color, tty, reset,
            cmd_color, cmd, reset;
    }
}
