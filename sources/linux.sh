### Bash Profile: Linux Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Version: 1.0
### Aliases and functions specific to Linux flavors of UNIX (RedHat/CentOS/Ubuntu)

if [ $(uname) != "Linux" ]; then
	echo "Not running Linux, not loading profile";
	return 1;
fi

# Exports
export PATH=/sbin:/usr/sbin/:$PATH;
if [ -f /etc/redhat-release ]; then
    export OS_NAME='RedHat';
    export OS_VERSION=$(cat /etc/redhat-release);
elif [ -f /etc/lsb-release ]; then
    export OS_NAME='Ubuntu';
    export OS_VERSION=$(cat /etc/lsb-release);
fi

# Aliases
alias fstab='sudo $EDITOR /etc/fstab';
alias flushdns='sudo /etc/init.d/nscd restart';
alias free='free -m';
alias ps='ps -aef';
alias psgrp='ps -aef | grep -i';
function bandwidth_stats { ifconfig $1 | grep 'RX bytes'; }
function ktunnel() { pids=$(ps | grep '[s]sh \-D 8080' | awk '{print $2}'); if [ -n "$pids" ]; then kill $pids; fi }
function md5() { md5sum $1 | cut -d ' ' -f1; }
function smd5() { sudo md5sum $1 | cut -d ' ' -f1; }
# Complete ssh and scp
_ssh(){
    local cur opts;
    # the current partially completed word
    cur="${COMP_WORDS[COMP_CWORD]}";
    # the list of possible options - what we have found reading known_hosts
    opts=$(sed '{ s/^\([^ ]*\) .*$/\1/; s/^\(.*\),.*$/\1/ }' $HOME/.ssh/known_hosts);
    # return the possible completions as a list
    COMPREPLY=($(compgen -W "${opts}" ${cur}));
}
complete -F _ssh ssh scp;
