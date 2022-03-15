############################################
# Start ssh-agent
# adapted from https://stackoverflow.com/questions/40549332/how-to-check-if-ssh-agent-is-already-running-in-bash

TITLE Enabling ssh-agent . . .

SSH_ENV="$HOME/.ssh/environment"

function check-ssh-agent {
  ssh-add -l &> /dev/null
  if [[ "$?" == 2 ]]; then
    # Try to connect to running ssh-agent
    if [ -f "${SSH_ENV}" ]; then
      . "${SSH_ENV}" > /dev/null
    fi
  fi

  ssh-add -l &> /dev/null
  if [[ "$?" == 2 ]]; then
    # Try to restart ssh-agent
    (umask 066; /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}")
    . "${SSH_ENV}" > /dev/null
  fi

  ssh-add -l &> /dev/null
  if [[ "$?" == 1 ]]; then
    ssh-add
  fi
  ssh-add -l
}

check-ssh-agent