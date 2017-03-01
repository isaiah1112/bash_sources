### Bash Profile: Profile for Darwin (OS X)
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

## Aliases
if [ -d /Applications/Atom.app ]; then
	alias atom="open -a 'Atom'";
fi
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
alias md5='md5 -q';
alias smd5='sudo md5 -q ';
alias softwareupdate='sudo softwareupdate';
if [ -d /Applications/TextWrangler.app ]; then
    alias txtw="open -a 'TextWrangler'";
fi

# Do macports stuff (if installed)
if [ -f /opt/local/bin/port ]; then
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH";
    alias portupdate="sudo port selfupdate; sudo port upgrade outdated";
    alias portclean="sudo port clean -f --all installed; sudo port -f uninstall inactive";
fi

# Add ssh key to ssh-agent (if it exists)
if [ -f ~/.ssh/id_rsa ]; then
    ssh-add -K ~/.ssh/id_rsa 2>/dev/null;
    alias ssh='ssh -A';
fi

# If pdsh is installed, force it to use ssh
if [ -n $(which pdsh 2>/dev/null) ]; then
    export PDSH_RCMD_TYPE=ssh;
fi

if [ -n $(which ffmpeg 2> /dev/null) ]; then
	# if ffmpeg is installed, create a function for converting to mp4 containers
    function mkv2mp4() {
        if [ -z "$1" -o "$1" == "--help" ]; then
            echo 'USAGE: mkv2mp4 <mkv> [mp4]';
            return 0;
        fi
        mkvname=$1;
        if [ -z "$2" ]; then
            mp4name=$(echo "$mkvname" | sed 's/\.mkv/\.mp4/g');
        else
            mp4name=$2
        fi
        ffmpeg -i "$mkvname" -c:v copy -c:a copy "$mp4name";
    }
fi

# Wrapper for sshfs that will create the mountpoint if it doesn't exist
if [ -n $(which sshfs 2>/dev/null) ]; then
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
				/usr/local/bin/sshfs $@;
				sleep 1;
				open $mountPoint;
			fi
		else
			mkdir $mountPoint;
			/usr/local/bin/sshfs $@;
			sleep 1;
			open $mountPoint;
		fi
	}
fi

# GhostScript functions
if [ -n $(which gs 2>/dev/null) ]; then
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
