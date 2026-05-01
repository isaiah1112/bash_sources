### Linux specific settings
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions specific to Linux flavors of UNIX (RedHat/CentOS/Ubuntu)

if [[ $(uname) != "Linux" ]]; then
    echo "Not running Linux. Not loading source."
    return 1
fi

# Add sbin to PATH if not already present
if [[ ":$PATH:" != *:/sbin:* ]] && [[ -d /sbin ]]; then
    export PATH="/sbin:/usr/sbin:$PATH"
fi

# Detect OS name and version
if [[ -f /etc/redhat-release ]]; then
    export OS_NAME='RedHat'
    OS_VERSION=$(cat /etc/redhat-release)
elif [[ -f /etc/lsb-release ]]; then
    export OS_NAME='Ubuntu'
    OS_VERSION=$(cat /etc/lsb-release)
fi

# Aliases
alias fstab='sudo $EDITOR /etc/fstab'
alias flushdns='sudo systemd-resolve --flush-caches'
alias free='free -m'
alias portgrp='sudo ss -lp | grep -i';

# Network stats using modern 'ip' command
bandwidth_stats() {
    if [[ -z "$1" ]]; then
        echo "Usage: bandwidth_stats <interface>"
        return 1
    fi
    ip -s link show "$1" | grep -E 'RX:|TX:'
}

# Kill SSH tunnel on port 8080
ktunnel() {
    local pids
    pids=$(ps aux | grep '[s]sh -D 8080' | awk '{print $2}')
    if [[ -n "$pids" ]]; then
        kill $pids
    fi
}

# MD5 checksum (wraps md5sum)
md5check() { md5sum "$1" | cut -d ' ' -f1; }
smd5check() { sudo md5sum "$1" | cut -d ' ' -f1; }

# SSH/SCP completion from known_hosts
_ssh_completion() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$(sed 's/^\([^ ]*\) .*$/\1/; s/^\(.*\),.*$/\1/' "$HOME/.ssh/known_hosts" 2>/dev/null)
    COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
}
complete -F _ssh_completion ssh scp
