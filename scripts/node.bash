TITLE Setting up Node.js . . .

for nvm_install in "/opt/homebrew/opt/nvm"; do
    if [[ -e "${nvm_install}/nvm.sh" ]]; then
        INFO "Loading nvm from ${nvm_install}"
        [ -s "${nvm_install}/nvm.sh" ] && \. "${nvm_install}/nvm.sh"  # This loads nvm
        [ -s "${nvm_install}/etc/bash_completion.d/nvm" ] && \. "${nvm_install}/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        break
    fi
done