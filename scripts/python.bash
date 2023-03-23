function pyenv()
{ 
    if VENV=$(python3 -m pipenv --venv)
    then
        source $VENV/bin/activate
    fi
}