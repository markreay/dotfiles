toolchain() {
    local config="$DOTFILES/.toolchains"
    [[ -f $config ]] || echo -e "Python: false\nAzure: false" > "$config"

    case "$1" in
        is-enabled)
            local key=$(echo "$2" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
            if grep -q "^$key: true" "$config"; then
                return 0
            else
                return 1
            fi
            ;;
        *)
            # Current states
            local python_state=$(grep "^Python:" "$config" | awk '{print $2}')
            local azure_state=$(grep "^Azure:" "$config" | awk '{print $2}')

            local options=$(cat <<EOF
Python    [$python_state]
Azure     [$azure_state]
EOF
)

            local selected=$(echo "$options" | fzf --multi --header "Toggle toolchains (space = select, enter = confirm)")

            # Reset config
            echo "Python: false" > "$config"
            echo "Azure: false" >> "$config"

            # Update based on selection
            if echo "$selected" | grep -q "Python"; then
                sed -i.bak 's/Python: false/Python: true/' "$config"
                echo "🟢 Python toolchain enabled"
            else
                echo "🔴 Python toolchain disabled"
            fi

            if echo "$selected" | grep -q "Azure"; then
                sed -i.bak 's/Azure: false/Azure: true/' "$config"
                echo "🟢 Azure toolchain enabled"
            else
                echo "🔴 Azure toolchain disabled"
            fi
            ;;
    esac
}