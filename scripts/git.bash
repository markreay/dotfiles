TITLE Setting up git . . .

############################################
# Set default editor to VIM
export EDITOR=vim

(
    if [[ $CODESPACES ]]; then
        # Codespaces doesn't support global configuration - configuration is per repo
        return 0 2>/dev/null || exit 0
    fi

    EXPECTED_INIT_DEFAULTBRANCH=main
    EXPECTED_USER_NAME="Mark Reay"
    EXPECTED_USER_EMAIL="markreay@gmail.com"

    git_check_and_set() {
        local key="$1"
        local expected="$2"
        local current
        current=$(git config --global --get "$key")

        if [[ -z "$current" ]]; then
            WARNING "$key not set"
            FIX "git config --global $key \"$expected\""
        elif [[ "$current" != "$expected" ]]; then
            WARNING "$key is \"$current\" (should be \"$expected\")"
            FIX "git config --global $key \"$expected\""
        fi
    }

    git_check_and_set init.defaultBranch "$EXPECTED_INIT_DEFAULTBRANCH"
    git_check_and_set user.name "$EXPECTED_USER_NAME"
    git_check_and_set user.email "$EXPECTED_USER_EMAIL"
)