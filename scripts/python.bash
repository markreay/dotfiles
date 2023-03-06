function pyenv()
{ 
    if VENV=$(pipenv --venv)
    then
        source $VENV/bin/activate
    fi
}