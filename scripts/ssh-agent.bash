############################################
# Start ssh-agent
# adapted from http://mah.everybody.org/docs/ssh

TITLE Enabling ssh-agent . . .

SSH_ENV="$HOME/.ssh/environment"

function start_ssh_agent {
    INFO "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    INFO succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    
    if [ "$(basename $(ps -o command -p ${SSH_AGENT_PID} | tail -1 | cut -f1 -d' ') 2>/dev/null)" != "ssh-agent" ]; then
        WARNING "ssh-agent not running on ${SSH_AGENT_PID} as expected . . . restarting"
        start_ssh_agent;
    else
        INFO "SSH agent already running on PID ${SSH_AGENT_PID}"
    fi
else
    start_ssh_agent;
fi
