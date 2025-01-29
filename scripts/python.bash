function pyenv()
{ 
    if VENV=$(python3 -m pipenv --venv)
    then
        source $VENV/bin/activate
        if [ -f $VENV/.env ]
        then
            source $VENV/.env
        fi
    fi
}