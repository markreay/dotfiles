TITLE Enabling gnupg . . .

export GPG_TTY=$(tty)

function check_gpg() {
    GPG_PUBLIC_KEY=$(gpg --with-colons --list-key $GPG_SIGNING_KEY | grep ^fpr | head -1 | cut -d: -f10)
    if [[ -z $GPG_PUBLIC_KEY ]]; then
        WARNING "No gpg key registered"
        FIX "to fix: gpg --import private.key"
        return 1;
    fi

    GPG_SIGNING_KEY=$(git config --get user.signingkey)
    if [[ "$GPG_PUBLIC_KEY" != "$GPG_SIGNING_KEY" ]]; then
        WARNING "No valid gpg signing key in .gitconfig"
        FIX "to fix: git config --global user.signingkey $GPG_PUBLIC_KEY"
        return 1;
    fi

    if ! (gpg --list-key $GPG_SIGNING_KEY 2> /dev/null > /dev/null); then
        WARNING "git signing key not installed in gnupg "
        FIX "to fix: gpg --import private.key"
        return 1;
    fi

    GPG_TRUST_LEVEL=$(gpg --with-colons --list-key $GPG_SIGNING_KEY | grep ^pub | cut -d: -f2)
    if [[ $GPG_TRUST_LEVEL != "u" ]]; then
        WARNING "git signing key not doesn't have ultimate trust" 
        FIX "to fix: gpg --edit-key $GPG_SIGNING_KEY"
        FIX "then trust"
        return 1;
    fi
}

check_gpg