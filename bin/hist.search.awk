BEGIN {
    date_color               = "\033[38;5;201m" # Magenta
    tty_color                = "\033[38;5;36m"  # Cyan
    cmd_no_search_color      = "\033[0m"        # White
    cmd_search_match_color   = "\033[1;33m"     # Bright yellow
    cmd_search_nomatch_color = "\033[38;5;244m" # Soft gray
    reset                    = "\033[0m"

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
        if (n > 0) {
            # ✅ highlight matches
            for (j = 1; j <= n; j++) {
                gsub(terms[j], cmd_search_match_color terms[j] cmd_search_nomatch_color, cmd)
            }
            cmd_color = cmd_search_nomatch_color
        } else {
            cmd_color = cmd_no_search_color
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
