if toolchain is-enabled Python; then
    function initpy() {
        # Use pyenv if available
        if [ -f .python-version ] && command -v pyenv &>/dev/null; then
            PYTHON_VERSION=$(cat .python-version)
            if ! pyenv versions --bare | grep -qx "$PYTHON_VERSION"; then
                echo "[initpy] Installing Python $PYTHON_VERSION via pyenv..."
                pyenv install "$PYTHON_VERSION"
            fi
            pyenv local "$PYTHON_VERSION"
        fi

        # Check for .venv directory
        if [ -d .venv ]; then
            echo "[initpy] Activating .venv..."
            source .venv/bin/activate
            if [ -f .venv/.env ]; then
                source .venv/.env
            fi
        else
            echo "[initpy] No .venv directory found."
            echo "[initpy] Create one with: python -m venv .venv"
            return 1
        fi

        echo "[initpy] Python version: $(python --version)"
    }

    function initpy_old()
    { 
    # if pipenv exists, use that to get VENV, else
    # use python3 -m pipenv --venv

        if command -v pipenv &> /dev/null
        then
            VENV=$(pipenv --venv)
        else
            VENV=$(python3 -m pipenv --venv)
        fi
        if [ -z "$VENV" ]
        then
            echo "No virtual environment found."
            return 1
        fi
        source $VENV/bin/activate
        if [ -f $VENV/.env ]
        then
            source $VENV/.env
        fi

        echo "Activated virtual environment: $VENV"
        echo "Python version: $(python --version)"
    }

    if [ -d "$HOME/.pyenv" ]; then
        export PATH="$HOME/.pyenv/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    else
        echo "Pyenv not found in $HOME/.pyenv"
        return 1
    fi
fi