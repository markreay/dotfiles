BEGIN {
    date_color     = "\033[38;5;201m"   # Magenta
    tty_color      = "\033[38;5;36m"    # Cyan
    cmd_color      = "\033[38;5;244m"   # Soft gray
    highlight_start = "\033[1;33m"      # Bright yellow
    highlight_end   = cmd_color
    reset           = "\033[0m"

    n = split(TERMS, terms, "\t")
}

/^#/ {
    split(substr($0, 2), meta, ":")
    ts = meta[1]
    dir = meta[2]
    getline cmd

    match_all = 1
    for (i = 1; i <= n; i++) {
        if (index(cmd, terms[i]) == 0) {
            match_all = 0
            break
        }
    }

    if (match_all) {
        # ✅ highlight matches
        for (j = 1; j <= n; j++) {
            gsub(terms[j], highlight_start terms[j] highlight_end, cmd)
        }

        tty = FILENAME
        sub(/.*\//, "", tty)
        sub(/^[0-9\-]+_/, "", tty)

        printf "%s%s%s  %s%-8s%s  %s%s%s\n",
            date_color, strftime(DATE_FMT, ts), reset,
            tty_color, tty, reset,
            cmd_color, cmd, reset
    }
}
