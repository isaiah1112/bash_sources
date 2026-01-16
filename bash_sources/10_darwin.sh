### Darwin (OS X) specific settings
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions specific to Darwin flavors of UNIX (OS X)

if [ $(uname) != "Darwin" ]; then
	echo "Not running Darwin. Skipping source.";
	return 1;
fi

## ENV Exports
export OS_NAME=$(sw_vers -productName);
export OS_VERSION=$(sw_vers -productVersion);
export LESS='-R -F -X $LESS';

## Aliases
alias cp='cp -rp';
if [ -d /Applications/Google\ Chrome.app ]; then
    alias chrome='open -a "Google Chrome"';
fi
alias fdisk='fdisk -cu';
if [ -d /Applications/Firefox.app ]; then
    alias firefox='open -a "Firefox"';
fi
alias free='vm_stat';
alias la='ls -GlAh';
alias ll='ls -GlArt';
if [ -f /usr/bin/dscacheutil ]; then
    alias flushdns='sudo dscacheutil -flushcache';
else # You are running 10.4 or earlier
    alias flushdns='sudo lookupd -flushcache';
fi
if [ -f /usr/sbin/systemsetup ]; then
    alias systemsetup='sudo /usr/sbin/systemsetup';
    alias networksetup='sudo /usr/sbin/networksetup';
else
    alias systemsetup='sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/systemsetup';
    alias networksetup='sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/networksetup';
fi
alias md5q='md5 -q';
alias plist2xml='plutil -convert xml1';
alias plist2bin='plutil -convert binary1';
alias ssh='ssh -A';

# Add ssh key to ssh-agent (if it exists)
if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
elif [ -f ~/.ssh/id_rsa ]; then
    ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null
fi

# If pdsh is installed, force it to use ssh
if command -v pdsh &>/dev/null; then
    export PDSH_RCMD_TYPE=ssh
fi

# Complete ssh and scp
_ssh(){
    local cur opts;
    # the current partially completed word
    cur="${COMP_WORDS[COMP_CWORD]}";
    # the list of possible options - what we have found reading known_hosts
    opts=$(sed 's/^\([^ ]*\) .*$/\1/; s/^\(.*\),.*$/\1/' $HOME/.ssh/known_hosts);
    # return the possible completions as a list
    COMPREPLY=($(compgen -W "${opts}" ${cur}));
}
complete -F _ssh ssh scp;
