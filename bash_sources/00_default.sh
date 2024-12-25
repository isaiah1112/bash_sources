### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### The idea behind the defaults profile is to load things that work on any UNIX OS

# Environment Variables
# Set the Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# Set the Prompt
export PS1="\H:\u:\W$ ";
# Set History Options
export HISTCONTROL=ignoreboth:erasedupes;
export HISTSIZE=10000;
export HISTFILESIZE=10000;
shopt -s histappend;
# Set Editor Options
export LESS="iX";
export OS=$(uname);
if [ -n "$(which vim 2>/dev/null)" ]; then
    export EDITOR=$(which vim);
elif [ -n "$(which vi 2>/dev/null)" ]; then
    export EDITOR=$(which vi);
fi
export HOSTS="/etc/hosts";

# Basic Aliases
alias cp='cp -r';
alias cls='clear';
alias df='df -h';
alias du='du -shx';
alias e='exit';
alias hg='history | grep -i';
alias hostgrp="cat $HOSTS | grep -i ";
alias la='ls -lAh';
alias ll='ls -lh';
alias lns='ln -sfn';
alias portgrp='sudo netstat -lp | grep -i';
alias rm='rm -r';
alias ssu='sudo su -';
alias stail='sudo tail';
alias svi='sudo $EDITOR';
alias vi='$EDITOR';
alias wcl='wc -l';

# Functions
function b64encode() { echo -n $1 | base64; }
function b64decode() { echo $(echo -n $1 | base64 --decode;); }
# Backup a file with datestamp
function bu() { cp -p "$1" "$1_$(date +%Y%m%d-%H%M)_$(whoami)"; }
# Use help if no man page
function man() { /usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less) }
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
