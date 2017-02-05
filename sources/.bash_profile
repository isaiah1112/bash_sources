# Bash Profile
# Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
# License: LGPL3+ (http://choosealicense.com/licenses/lgpl-3.0/)
# Version: 2.6
function profile() {
case $1 in
    --edit|-E)
        if [ -z $2 ]; then
            $EDITOR ~/.bash_profile;
        else
            $EDITOR ~/.profiles.d/$2;
        fi
        source ~/.bash_profile;
    ;;
    --reload|-R) source ~/.bash_profile;
    ;;
    --info|-I)
        if [ -z $2 ]; then
            head -4 ~/.bash_profile;
            if [ -d ~/.profiles.d ]; then
                echo "# Profile Addons:";
                ls -1 ~/.profiles.d/;
            fi
        else
            head -4 ~/.profiles.d/$2;
        fi
    ;;
    *)
        echo 'profile [--edit|--info|--reload]';
esac
}
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
export HOSTS="/etc/hosts";
if [ -z "$EDITOR" ]; then
    export EDITOR=$(which vi 2>/dev/null);
fi
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
alias info='echo -e "Host: $HOSTNAME\nOS: $OS\nUID: `whoami`\nCWD: `pwd`\nEditor: $EDITOR";';
alias json='python -mjson.tool';
alias la='ls -lAh --color';
alias ll='ls -lArt --color';
alias ls='ls -lh --color';
alias lstunnel='ps | grep "[s]sh \-D 8080"'; ## Used in conjunction with tunnel and ktunnel
alias lns='ln -sfn';
alias lagrp='la | grep';
alias lsgrp='ls | grep';
alias myip="curl -s 'http://ip6.me/' | grep -A 1 'Address of' | cut -d '>' -f4 | cut -d '<' -f1";
alias pipclean='pip freeze | grep -v -f requirements.txt | xargs pip uninstall -y';
alias portgrp='sudo netstat -lp | grep -i';
# For quick registering and uploading to PyPi
alias pypi_upload="python setup.py sdist upload";
alias pypi_register="python setup.py register";
alias resolv='sudo $EDITOR /etc/resolv.conf';
alias rm='rm -r';
alias sgrep='sudo grep';
alias sharedir='python -m SimpleHTTPServer';
alias ssu='sudo su -';
alias sshr='sudo ssh';
alias stail='sudo tail';
alias starwars='telnet towel.blinkenlights.nl';
alias svi='sudo $EDITOR';
alias vi='$EDITOR'
alias vimrc='$EDITOR ~/.vimrc';
alias visudo="sudo visudo";
alias tracert='traceroute';
alias wcl='wc -l';

######### Universal bash functions

function b64_encode() { echo -n $1 | base64; }
function b64_decode() { echo $(echo -n $1 | base64 -d;); }

# Reverse SSH Tunnel for SOCKS proxy on port 8080
function ktunnel() {
if [ -n $(ps | grep '[s]sh \-D 8080' | awk '{print $2}') ]; then
    kill $pids;
fi
}
alias lstunnel='ps | grep "[s]sh \-D 8080"';
alias tunnel='ssh -D 8080 -f -C -q -N';

# Function for making man use help if no man page exists
function man() {
/usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less)
}

# Backup a file with datestamp
function bu() {
    DATE=`date +%Y%m%d%H%M`;
    ME=`who am i | cut -d " " -f1`;
    sudo cp -p $1 $1-$DATE-$ME;
    if [ -f $1-$DATE-$ME ]; then
        echo -e "Backed up $1-$DATE-$ME";
    else
        echo "Back up failed!";
    fi
}
function mkgz() {
    if [ -d $1 ]; then
        echo "Unable to gzip a directory!";
    else
        gzip -c9 $1 > $1.gz;
    fi
}
function untar() { tar -xf $@; }
function mktar() { tar -cf $1.tar $1; }
function mktgz() { tar -czf $1.tgz $1; }
function mktZ() { tar -cZf $@; }

######### Definitions and functions for different flavors of UNIX
if [ -d ~/.profiles.d ]; then
    for f in $(find ~/.profiles.d \( -type f -o -type l \)); do
        source $f;
    done
fi
