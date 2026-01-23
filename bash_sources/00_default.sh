### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### The idea behind the defaults profile is to load things that work on any UNIX OS

# Environment Variables
# Set the Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# Set the Prompt
export PS1="\H:\u:\W$ "
# Set History Options
export HISTCONTROL=ignoreboth:ignorespace:erasedupes
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend
shopt -s histverify
# Set Editor Options
export LESS="iX"
export OS=$(uname)
export EDITOR="${EDITOR:-$(command -v vim || command -v vi)}"
export HOSTS="/etc/hosts"

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
function b64encode() { echo -n "$1" | base64; }
function b64decode() { echo "$(echo -n "$1" | base64 --decode)"; }
# Backup a file with datestamp
function bu() { cp -p "$1" "$1_$(date +%Y%m%d-%H%M)_$(whoami)"; }
# Use help if no man page
function man() { /usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less) }
# Compression functions
function mkgz() {
    if [ -z "$1" ]; then
        echo "Usage: mkgz <file>"
        return 1
    elif [ ! -e "$1" ]; then
        echo "Error: File '$1' not found"
        return 1
    elif [ -d "$1" ]; then
        echo "Error: mkgz cannot compress directories (use mktgz instead)"
        return 1
    else
        gzip -c9 "$1" > "$1.gz"
    fi
}
function untar() { tar -xf "$@"; }
function mktar() {
    if [ -z "$1" ] || [ ! -e "$1" ]; then
        echo "Usage: mktar <file_or_directory>"
        return 1
    fi
    tar -cf "$1.tar" "$1"
}
function mktgz() {
    if [ -z "$1" ] || [ ! -e "$1" ]; then
        echo "Usage: mktgz <file_or_directory>"
        return 1
    fi
    tar -czf "$1.tgz" "$1"
}
function mktZ() { tar -cZf "$@"; }
