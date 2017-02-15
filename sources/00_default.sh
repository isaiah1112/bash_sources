### Bash Profile: Defaults
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### The idea behind the defaults profile is to load things that work on any UNIX OS
# Set the Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Universal bash commands and exports
export PS1="\H:\u:\W$ ";
export HISTCONTROL=ignoreboth:erasedupes;
export HISTSIZE=10000;
export HISTFILESIZE=10000;
shopt -s histappend; # append to history file
export LESS="iX";
export OS=$(uname);
export EDITOR=$(which vim 2>/dev/null);
if [ -z "$EDITOR" ]; then
    export EDITOR=$(which vi 2>/dev/null);
fi
export HOSTS="/etc/hosts";

# Aliases (Make them conditional if possible)
if [ -n $(which apg 2>/dev/null) ]; then
    alias apg="apg -a 1 -m 8 -x 20 -M NCL";
fi
alias cp='cp -r';
alias cls='clear';
alias df='df -kh';
alias dfgrp='df | grep -i';
alias digme='dig $HOSTNAME +short';
alias digx='dig -x';
alias du='sudo du -shx';
alias e='exit';
alias edithosts="sudo $EDITOR $HOSTS";
alias fu='sudo `history | tail -n2 | head -n1 | tr -s " " | cut -d " " -f3-`';
alias grepi='grep -i';
alias grepcfg='grep -v -E "^#|^$"';
alias hg='history | grep -i';
alias hostgrp="cat $HOSTS | grep -i ";
alias la='ls -lAh';
alias ll='ls -lArt';
alias ls='ls -lh';
alias lns='ln -sfn';
alias lagrp='la | grep';
alias lsgrp='ls | grep';
alias myip="curl -s 'http://ip6.me/' | grep -A 1 'Address of' | cut -d '>' -f4 | cut -d '<' -f1";
alias portgrp='sudo netstat -lp | grep -i';
# For quick registering and uploading to PyPi
alias resolv='sudo $EDITOR /etc/resolv.conf';
alias rm='rm -r';
alias sgrep='sudo grep';
alias ssu='sudo su -';
alias sshr='sudo ssh';
alias stail='sudo tail';
alias svi='sudo $EDITOR';
alias vi='$EDITOR'
alias vimrc='$EDITOR ~/.vimrc';
alias visudo="sudo visudo";
alias tracert='traceroute';
alias wcl='wc -l';

######### Universal bash functions

# These functions are similar to to how python would do things
function b64encode() { echo -n $1 | base64; }
function b64decode() { echo $(echo -n $1 | base64 -d;); }

# Reverse SSH Tunnel for SOCKS proxy on port 8080
function ktunnel() {
pids=$(ps aux | grep '[s]sh' | grep '\-D 8080' | awk '{print $2}');
if [ -n ${pids} ]; then
    kill ${pids};
fi
}
alias lstunnel="ps aux | grep '[s]sh' | grep '\-D 8080'";
alias tunnel='ssh -D 8080 -f -C -q -N';

# Function for making man use help if no man page exists
function man() { /usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less) }

# Backup a file with datestamp
function bu() { cp -p "$1" "$1_$(date +%Y%m%d-%H%M)_$(whoami)"; }

# Compression functions
function mkgz() {
    if [ -d "$1" ]; then
        echo "Unable to gzip a directory!";
    else
        gzip -c9 "$1" > "$1.gz";
    fi
}
function untar() { tar -xf $@; }
function mktar() { tar -cf "$1.tar" "$1"; }
function mktgz() { tar -czf "$1.tgz" "$1"; }
function mktZ() { tar -cZf $@; }
