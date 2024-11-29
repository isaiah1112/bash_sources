#!/bin/bash
# Install the bash_sources loader and setup our environment


if [ -z "$1" ]; then
    echo "USAGE: install.sh [bashrc|vimrc|sshcfg|<source>]";
    exit 0;
elif [ "$1" == "bashrc" ]; then
    # Backup and install bashrc
    mv $HOME/.bash_profile $HOME/.bash_profile.pre-bash_sources 2>/dev/null;
    mv $HOME/.bashrc $HOME/.bashrc.pre-bash_sources 2>/dev/null;
    ln -snf $(pwd)/bash_sources/bash_profile.sh $HOME/.bash_profile;
    ln -snf $(pwd)/bash_sources/bashrc.sh $HOME/.bashrc;
    mkdir -p $HOME/.bash_sources.d;
    ln -snf $(pwd)/bash_sources/00_default.sh $HOME/.bash_sources.d/00_default.sh;
    echo "bash_sources bashrc installed.  Please reload your terminal.";
    exit 0;
elif [ "$1" == "vimrc" ]; then
    # Backup and install vimrc
    mv $HOME/.vimrc $HOME/.vimrc.pre-bash_sources 2> /dev/null;
    ln -snf $(pwd)/vimrc $HOME/.vimrc;
    echo "vimrc installed";
    exit 0;
elif [ "$1" == "sshcfg" ]; then
    # Backup and install ssh config
    mv $HOME/.ssh/config $HOME/.ssh/config.pre-bash_sources 2>/dev/null;
    ln -snf $(pwd)/ssh/config $HOME/.ssh/config;
    echo "ssh config installed";
    exit 0;
else
    # Install the requested bash source
    if [ -d $HOME/.bash_sources.d ]; then
        if [ -f $(pwd)/bash_sources/$1 ]; then
            ln -snf $(pwd)/bash_sources/$1 $HOME/.bash_sources.d/$1;
            echo "$1 bash source installed.";
            echo "Please run 'profile reload' to load this new source.";
            exit 0;
        else
            echo "Unable to find $1 in bash_sources directory. Try again.";
            exit 1;
        fi
    else
        echo "Please run 'install.sh bashrc' and try again.";
        exit 1;
    fi
fi