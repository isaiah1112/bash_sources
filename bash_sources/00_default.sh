### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### The idea behind the defaults profile is to load things that work on any UNIX OS

# Safety: Exit on undefined variables
# set -u

# Environment Variables
# Set the Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set the Prompt (use \[ \] for non-printing chars)
PS1='\h:\u:\W$ '

# Set History Options
export HISTCONTROL=ignoreboth:ignorespace:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend
shopt -s histverify

# Set Editor Options
export LESS='-iX'
export OS=$(uname)
export EDITOR="${EDITOR:-$(command -v vim || command -v vi)}"
export HOSTS="/etc/hosts"

# Colorize Man Pages (per ysap.sh)
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'
export MANPAGER='less'

# Basic Aliases
alias cp='cp -R';
alias cls='clear';
alias df='df -h';
alias du='du -shx';
alias e='exit';
alias hg='history | grep -i';
alias hostgrp="grep -i $HOSTS";
alias la='ls -lAh';
alias ll='ls -lh';
alias lns='ln -sfn';
alias ssu='sudo su -';
alias stail='sudo tail';
alias svi='sudo $EDITOR';
alias vi='$EDITOR';
alias wcl='wc -l';

# Functions
# Base64 encode/decode
b64encode() { echo -n "$1" | base64; }
b64decode() { echo -n "$1" | base64 --decode; }

# Backup a file with datestamp
bu() { cp -p "$1" "$1_$(date +%Y%m%d-%H%M)_$(whoami)"; }

# Compression functions
mkgz() {
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

untar() { tar -xf "$@"; }

mktar() {
    if [ -z "$1" ] || [ ! -e "$1" ]; then
        echo "Usage: mktar <file_or_directory>"
        return 1
    fi
    tar -cf "$1.tar" "$1"
}

mktgz() {
    if [ -z "$1" ] || [ ! -e "$1" ]; then
        echo "Usage: mktgz <file_or_directory>"
        return 1
    fi
    tar -czf "$1.tgz" "$1"
}

mktZ() { tar -cZf "$@"; }
