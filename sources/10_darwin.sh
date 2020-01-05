### Bash Profile: Profile for Darwin (OS X)
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions specific to Darwin flavors of UNIX (OS X)

if [ $(uname) != "Darwin" ]; then
	echo "Not running Darwin. Skipping source.";
	return 1;
fi

# In Catalina (10.15) bash is no longer the default shell.
export BASH_SILENCE_DEPRECATION_WARNING=1;

## ENV Exports
export OS_NAME=$(sw_vers -productName);
export OS_VERSION=$(sw_vers -productVersion);
export LESS='-R -F -X $LESS';

## Aliases
alias bandwidth_stats="top -l 1 | grep Networks | sed 's/[0-9]*\///g' | sed 's/ packets://g'";
alias bandwidth_stats_live="netstat -w1 -I";
alias cp='cp -rp';
if [ -d /Applications/Google\ Chrome.app ]; then
    alias chrome='open -a "Google Chrome"';
fi
alias empty_trash='rm ~/.Trash/* 2>/dev/null';
alias fdisk='fdisk -cu';
if [ -d /Applications/Firefox.app ]; then
    alias firefox='open -a "Firefox"';
fi
alias free='vm_stat';
alias la='ls -GlAh';
alias ll='ls -GlArt';
alias ls='ls -Glh';
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
alias softwareupdate='sudo softwareupdate';
if [ -d /Applications/TextWrangler.app ]; then
    alias txtw="open -a 'TextWrangler'";
fi

# Do macports stuff (if installed)
if [ -f /opt/local/bin/port ]; then
    export PATH="/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin/:$PATH";
    alias portupdate="sudo port selfupdate; sudo port upgrade outdated";
    alias portclean="sudo port clean -f --all installed; sudo port -f uninstall inactive";
fi

# Add ssh key to ssh-agent (if it exists)
if [ -f ~/.ssh/id_rsa ]; then
    ssh-add -K ~/.ssh/id_rsa 2>/dev/null;
    alias ssh='ssh -A';
fi

# If pdsh is installed, force it to use ssh
if [ -n "$(which pdsh 2>/dev/null)" ]; then
    export PDSH_RCMD_TYPE=ssh;
fi

# Wrapper for sshfs that will create the mountpoint if it doesn't exist
sshfsloc=$(which sshfs 2>/dev/null);
if [ -n "${sshfsloc}" ]; then
	# Wrapper for sshfs that will create the mountpoint if it doesn't exist
	function sshfs() {
		mountPoint=${@:$#};
		if [ -d "$mountPoint" ]; then
			mounted=$(df | grep $mountPoint);
			if [ -n "$mounted" ]; then
				echo "$mountPoint is already mounted";
				sleep 1;
				open $mountPoint;
			else
				${sshfsloc} $@;
				sleep 1;
				open $mountPoint;
			fi
		else
			mkdir $mountPoint;
			${sshfsloc} $@;
			sleep 1;
			open $mountPoint;
		fi
	}
fi

# GhostScript functions
if [ -n "$(which gs 2>/dev/null)" ]; then
	# Run an encrypted pdf through a print function to decrypt it
	function decrypt_pdf () {
            if [ -z "$1" ]; then
                echo "USAGE: decrypt_pdf PDF";
            else
		output=$(echo $1 | sed 's/\.pdf/_decrypted\.pdf/');
		gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$output" -dPDFSETTINGS=/prepress -f "$1";
            fi
	}
	# Convert a PDF to jpg files
	function pdf2jpg () {
            if [ -z "$1" ]; then
                echo "USAGE: pdf2jpg PDF";
            else
		outname=$(echo "$1" | sed 's/\.pdf//');
		curpath=$(dirname "$1");
		if [ ! -d "$curpath/$outname" ]; then
			mkdir -p "$curpath/$outname";
		fi
		gs -dNOPAUSE -dBATCH -sDEVICE=jpeg -dJPEGQ=100 -sOutputFile="${curpath}/${outname}/${outname} %03d.jpg" "$1";
            fi
	}
fi

# Set perms for wireshark
sudo chmod 705 /dev/bpf*;

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

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
  source /opt/local/etc/profile.d/bash_completion.sh
fi
