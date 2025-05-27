function pyenv()
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