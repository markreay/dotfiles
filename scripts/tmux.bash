# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "⚠️  Warning: tmux is not installed"
    if is_macos; then
        echo "   Install with: brew install tmux"
    else
        echo "   Install with: sudo apt-get install tmux (Ubuntu/Debian) or sudo yum install tmux (CentOS/RHEL)"
    fi
    return
fi

# Check if tmux.conf is sourced in ~/.tmux.conf
TMUX_CONF="$HOME/.tmux.conf"
DOTFILES_TMUX_CONF="$HOME/.dotfiles/tmux/tmux.conf"

if [[ -f "$TMUX_CONF" ]]; then
    if ! grep -q "source.*\.dotfiles/tmux/tmux\.conf" "$TMUX_CONF" 2>/dev/null; then
        echo "⚠️  Warning: ~/.tmux.conf does not source the dotfiles tmux.conf"
        echo "   Add this line to ~/.tmux.conf:"
        echo "   source-file ~/.dotfiles/tmux/tmux.conf"
    fi
else
    echo "⚠️  Warning: ~/.tmux.conf not found"
    echo "   Create ~/.tmux.conf and add:"
    echo "   source-file ~/.dotfiles/tmux/tmux.conf"
fi
