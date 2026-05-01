### Docker Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have docker installed

if ! command -v docker &>/dev/null; then
    echo "Docker is not installed. Not loading source."
    return 1
fi

# Remove dangling images
drmi() {
    docker image prune -f
}

# Remove stopped containers
drmps() {
    docker container prune -f
}

# Common docker shortcuts
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop'
alias dstart='docker start'
alias dstat='docker stats'
