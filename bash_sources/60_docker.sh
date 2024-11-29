### Bash Profile: Docker Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have docker installed

if [ -z $(which docker 2> /dev/null) ]; then
	echo "docker is not installed. Not loading source.";
	exit 1;
fi

alias docker_clean_images="docker rmi $(docker images -a --filter=dangling=true -q)";
alias docker_clean_ps="docker rm $(docker ps --filter=status=exited --filter=status=created -q)";
