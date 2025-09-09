function check_gpg() {
    export GPG_TTY=$(tty)

    TITLE Enabling gnupg . . .

    if ! which gpg > /dev/null
    then
        WARNING "gpg not installed"
        return 1;
    fi

    get_gpg_signing_fpr_by_user_id() {
        local email="$1"
        gpg --list-keys --with-colons "$email" |
            awk -F: '
                $1=="sub" && $12 ~ /s/ {found=1} 
                found && $1=="fpr" {print $10; exit}
            '
    }

    local USER_ID=$(git config --global --get user.email)

    local public_key=$(get_gpg_signing_fpr_by_user_id $USER_ID)
    if [[ -z $public_key ]]; then
        WARNING "No gpg key registered for $USER_ID"
        FIX "to fix: gpg --import private.key"
        return 1;
    fi

    local signing_key=$(git config --get user.signingkey)
    if [[ "$public_key" != "$signing_key" ]]; then
        WARNING "No valid gpg signing key in .gitconfig"
        FIX "to fix: git config --global user.signingkey $public_key"
        return 1;
    fi

    if ! (gpg --list-key $signing_key 2> /dev/null > /dev/null); then
        WARNING "git signing key not installed in gnupg "
        FIX "to fix: gpg --import private.key"
        return 1;
    fi

    if [[ "$(git config --global --get commit.gpgsign)" != "true" ]]
    then
        WARNING "git gpg signing not enabled"
        FIX "to fix: git config --global commit.gpgsign true"
    fi

    local trust_level=$(gpg --with-colons --list-key $signing_key | grep ^pub | cut -d: -f2)
    if [[ $trust_level != "u" ]]; then
        WARNING "git signing key does not have ultimate trust" 
        FIX "to fix: gpg --edit-key $signing_key"
        FIX "then trust"
        return 1;
    fi

    function check_gpg_agent_conf {
        local key="$1"
        local min_value="$2"
        local file=~/.gnupg/gpg-agent.conf
        local val=$(grep $key $file | cut -d ' ' -f 2)
        if [[ -z $val ]]
        then 
            WARNING "gpg-agent.conf is missing $key" 
            FIX "vi $file and add line \"$key $min_value\""
        elif (( $val < $min_value ))
        then
            WARNING "gpg-agent.conf has a $key of $val" 
            FIX "vi $file and set \"$key\" to $min_value or higher"
        fi
    }

    check_gpg_agent_conf default-cache-ttl 86400
    check_gpg_agent_conf max-cache-ttl 86400

    # Force gpg-agent to prompt passphrase now so future commits are seamless
    echo Force passphrase entry on login | gpg --detach-sign - > /dev/null

    INFO "GPG git signing is properly configured for $USER_ID"
}

function refresh_gpg() {
    if [[ ! $CODESPACES ]]
    then
        gpgconf --kill gpg-agent
        check_gpg
    fi
}

[[ ! $CODESPACES ]] && check_gpg
